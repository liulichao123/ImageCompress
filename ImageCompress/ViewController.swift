//
//  ViewController.swift
//  ImageCompress
//
//  Created by 天明 on 2018/4/3.
//  Copyright © 2018年 天明. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    @IBAction func selectImage(_ sender: Any) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = .photoLibrary
        imagePickerVC.delegate = self
        imagePickerVC.allowsEditing = true
        present(imagePickerVC, animated: true, completion: nil)
    }
    var scale: CGFloat = 1
    @IBAction func compress(_ sender: Any) {
        imageView.image = image.compress1(200)
//        let data = UIImageJPEGRepresentation(image, 0.01)!
//        let img = UIImage(data: data)
//        print("压缩后", data.count/1024, img?.cgImage?.width, img?.cgImage?.height)
//        try? data.write(to: URL(fileURLWithPath: "/Users/quanzizhangben/Desktop/test.jpg"))
//        imageView.image = img
    }

}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info["UIImagePickerControllerEditedImage"] as? UIImage else { return }
//        guard let originImage = info["UIImagePickerControllerOriginalImage"] as? UIImage else { return }
        imageView.image = image
        self.image = image
        print(info["UIImagePickerControllerEditedImage"])
        print("原始图片大小 k", UIImageJPEGRepresentation(image, 1)!.count/1024, "KB")
    }
}
