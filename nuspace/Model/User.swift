//
//  User.swift
//  nuspace
//
//  Created by Jonathon F Vega on 11/1/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage

// TODO: Setup for retrieval of user personal image from storage instead of just the default image
class User {
    var name: String?
    var username: String?
    var userImage: UIImage?
    
    var storageRef: StorageReference!
    
    init(name:String, username:String) {
        self.name = name
        self.username = username
        getUserImage()
    }
    
    func getUserImage() {
        storageRef = Storage.storage().reference()
        let fileURL = "https://firebasestorage.googleapis.com/v0/b/nuspace-a5b5b.appspot.com/o/DefaultUserImage.png?alt=media&token=8022761e-521c-49c2-937e-a596e78e2686"
        
        let userDefaultImage = storageRef.child(fileURL)
        userDefaultImage.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if(error != nil) {
                print("There was an error in downloading default image")
            } else {
                self.userImage = UIImage(data: data!)
            }
        }
    }
    
    /*func getUserImage() -> UIImage {
        return nil
    }*/
}
