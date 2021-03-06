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
import FirebaseStorage
import CoreData

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

        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {

            selectedImageFromPicker = editedImage

        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {

            selectedImageFromPicker = originalImage
        }

        let uid = FIRAuth.auth()?.currentUser?.uid

        if let selectedImage = selectedImageFromPicker {

            profileImageView.image = selectedImage

            let selectedImgData = NSData(data: UIImagePNGRepresentation(selectedImage)!)

            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserMO")
            request.predicate = NSPredicate(format: "id == %@", uid!)

            do {
                guard let results = try context.fetch(request) as? [UserMO] else {

                    return }

                    results[0].profileImage = selectedImgData

                try context.save()
                print ("kinda saved")

            } catch {
                print (error.localizedDescription)
            }

            let imageName = UUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("profileImages").child("\(imageName).png")
            if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!) {
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in

                    if error != nil {
                        print (error)
                        return
                    }

                    if let urlString = metadata?.downloadURL()?.absoluteString {
                        print ("good to go")

                        let ref = FIRDatabase.database().reference().child("users").child(uid!)
                        ref.updateChildValues(["prfileImgURL": urlString])

                    }

                    print (metadata)

                })
            }

        }

        dismiss(animated: true, completion: nil)
    }

}
