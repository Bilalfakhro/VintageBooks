//
//  AuthService.swift
//  VintageBooks
//
//  Created by Bilal Fakhro on 2018-11-27.
//  Copyright © 2018 Bilal Fakhro. All rights reserved.
//

import Firebase

class AuthService {
    
    // CALL IT DIRECTLY ON THE CLASS IT SELF
    static func signIn(email: String, password: String, onSuccess: @escaping ()-> Void, onError: @escaping (_ errorMessage: String)-> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            // CALL ON PERFORM SEGUE METHOD
            onSuccess()
        })
    }
}

//static func signUp(username: String, email: String, password: String, imageData: Data, onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
//    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
//        if error != nil {
//            onError(error!.localizedDescription)
//            return
//        }
//        let uid = user?.uid
//        let storageRef = FIRStorage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("profile_image").child(uid!)
//        
//        storageRef.put(imageData, metadata: nil, completion: { (metadata, error) in
//            if error != nil {
//                return
//            }
//            let profileImageUrl = metadata?.downloadURL()?.absoluteString
//            
//            self.setUserInfomation(profileImageUrl: profileImageUrl!, username: username, email: email, uid: uid!, onSuccess: onSuccess)
//        })
//    })
//    
//}
//
//static func setUserInfomation(profileImageUrl: String, username: String, email: String, uid: String, onSuccess: @escaping () -> Void) {
//    let ref = FIRDatabase.database().reference()
//    let usersReference = ref.child("users")
//    let newUserReference = usersReference.child(uid)
//    newUserReference.setValue(["username": username, "email": email, "profileImageUrl": profileImageUrl])
//    onSuccess()
//}
//}
//
