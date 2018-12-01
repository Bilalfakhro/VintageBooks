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

