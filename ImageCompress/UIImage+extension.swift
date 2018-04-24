//
//  UIImage+extension.swift
//  ImageCompress
//
//  Created by 天明 on 2018/4/3.
//  Copyright © 2018年 天明. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    //推荐方法1
    
    /// maxLength (KB) 300 先压缩尺寸maxWidth,再压缩质量
    func compress1(_ maxCount: Int = 300, maxWidth: Int = 750) -> UIImage? {
        let _max = maxCount * 1024
        guard let orginData = UIImageJPEGRepresentation(self, 1), orginData.count > _max else { return self }
        
        var count = orginData.count
        guard count > _max else { return  self }
        //1尺寸压缩 maxWidth
        let maxW: CGFloat = CGFloat(maxWidth)
        var byScale: CGSize
        if self.size.width > self.size.height && self.size.height > maxW { //横着拍摄
            byScale = CGSize(width: Int(self.size.width / self.size.height * maxW), height: Int(maxW))
        } else if self.size.height >= self.size.width && self.size.width > maxW { //竖着拍摄
            byScale = CGSize(width: Int(maxW), height: Int(self.size.height / self.size.width * maxW))
        } else {
            return UIImageJPEGRepresentation(self, 0.75).flatMap { UIImage(data: $0) }
        }
        guard let img = self.resize(size: byScale) else { return nil }
        
        //2质量压缩
        guard var newImgData = UIImageJPEGRepresentation(img, 1) else { return nil }
        var scale: CGFloat = 1
        count = newImgData.count
        while count > _max && scale > 0.02 {
            scale *= 0.7
            guard let data = UIImageJPEGRepresentation(img, scale) else {
                return nil
            }
            newImgData = data
            count = data.count
        }
        if count <= _max { return UIImage(data: newImgData) }
        return nil
    }
    
    /// maxLength(默认300KBKB)  先压缩质量,再压缩尺寸
    func compress2(_ maxCount: Int = 300) -> UIImage? {
        let _max = maxCount * 1024
        guard var orginData = UIImageJPEGRepresentation(self, 1), orginData.count > _max else { return self }
        //1质量压缩
        var count = orginData.count
        var scale: CGFloat = 1

        while count > _max && scale > 0.01 {
            scale *= 0.7
            guard let data = UIImageJPEGRepresentation(self, scale) else {
                return nil
            }
            orginData = data
            count = data.count
        }
        if count <= _max { return UIImage(data: orginData) }
        guard let img = UIImage(data: orginData), let cgImg = img.cgImage else { return nil }
        //2尺寸压缩
        var scale1: CGFloat = 1
        var w = cgImg.width
        var h = cgImg.height
        
        while count > _max {
            scale1 *= 0.7
            w = Int(CGFloat(w)*scale1)
            h = Int(CGFloat(h)*scale1)
            guard let new = img.resize(size: CGSize(width: w, height: h)) else { return nil }
            guard let data = UIImageJPEGRepresentation(new, 1) else { return nil }
            orginData = data
            count = data.count
        }
        return UIImage(data: orginData)
    }
    
    // 重绘制大小
    func resize(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.interpolationQuality = .none //放大时插值
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        guard let new = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext();
        return new;
    }
}
