//
//  LoginHandler.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/4/12.
//  Copyright © 2017年 my app. All rights reserved.
//

import Foundation
import UIKit
import Firebase


extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleSelectImage() {
        let picker = UIImagePickerController()
        
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print ("canceled picker")
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print (info)
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            
            selectedImageFromPicker = editedImage
            
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            
            selectedImageFromPicker = originalImage
        }
        
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage

            
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    
}

