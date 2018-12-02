//
//  AddViewController.swift
//  VintageBook
//
//  Created by Bilal Fakhro on 2018-11-26.
//  Copyright © 2018 Bilal Fakhro. All rights reserved.
//

import UIKit
import Firebase

class AddViewController: UIViewController {
    
    @IBOutlet weak var removeButton: UIBarButtonItem!
    
    @IBOutlet weak var bookTitleTextfield: UITextField!
    @IBOutlet weak var bookPhotoImageView: UIImageView!
    @IBOutlet weak var captionTextfield: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    
    var selectedPhoto: UIImage?
    var ref: DatabaseReference?
    let userID = Auth.auth().currentUser?.uid

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddViewController.handleSelectPhoto))
        bookPhotoImageView.addGestureRecognizer(tapGesture)
        bookPhotoImageView.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handlePost()
    }
    
    func handlePost() {
        if selectedPhoto != nil {
            self.shareButton.isEnabled = true
            self.removeButton.isEnabled = true
            self.shareButton.backgroundColor = .black
        } else {
            self.shareButton.isEnabled = false
            self.removeButton.isEnabled = false
            self.shareButton.backgroundColor = .lightGray
        }
    }
    
    // KEYBOARD DISMISS ONCLICK ANYWHERE
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func handleSelectPhoto() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: false, completion: nil)
    }
    
    @IBAction func shareButton_TouchUpInside(_ sender: Any) {
      //  view.endEditing(true)
        if let uploadData = selectedPhoto?.jpegData(compressionQuality: 0.1) {
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("Book_Photo").child(userID!).child(imageName)
            storageRef.putData(uploadData, metadata: nil, completion: { (_, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                storageRef.downloadURL(completion: { (url, error) in
                    if let error = error {
                        print(error)
                        return
                    }
                guard let url = url else { return }
                let photoUrl = url.absoluteString
                    self.sendDataToDatabase(photoUrl: photoUrl)
                })
            })
            } else {
            print("Profile Image can't be empty")
            clean()
        }
    }

    @IBAction func remove_TouchUpInside(_ sender: Any) {
        clean()
        handlePost()
    }
    
    func sendDataToDatabase(photoUrl: String) {
        let ref = Database.database().reference()
        let postsReference = ref.child("Users").child(userID!).child("Posts")
        let newPostId = postsReference.childByAutoId().key
        let newPostReference = postsReference.child(newPostId!)
        newPostReference.setValue(["Photo_Url": photoUrl], withCompletionBlock: {
            (error, ref) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            print("Success")
            self.clean()
            self.tabBarController?.selectedIndex = 0
        })
    }
    
    // EMPTY FIELDS AFTER PUSHING THE "SHARE" BUTTON
    func clean() {
        self.captionTextfield.text = ""
        self.bookPhotoImageView.image = UIImage(named: "placeholder-photo")
        self.bookTitleTextfield.text = ""
    }
}

extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedPhoto = image
            bookPhotoImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
