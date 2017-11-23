//
//  SettingsVC.swift
//  nuspace
//
//  Created by Jonathon F Vega on 11/23/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func logoutUser(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            print((Auth.auth().currentUser?.email)!)
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                dismiss(animated: true, completion: nil)
            } catch let signOutError as NSError{
                print("Error signing out: %@", signOutError)
            }
        }
    }
    
}
