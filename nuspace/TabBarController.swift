//
//  TabBarController.swift
//  nuspace
//
//  Created by Jonathon F Vega on 10/19/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class TabBarController: UITabBarController {
    
    var ref: DatabaseReference!
    
    let button = UIButton.init(type: .custom)
    var postSpaceView: UIView?
    var postMessageTextView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        buildCreatePostButton()
        
        if let arrayOfTabBarItems = self.tabBar.items as AnyObject as? NSArray,let tabBarItem = arrayOfTabBarItems[2] as? UITabBarItem {
            tabBarItem.isEnabled = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.frame = CGRect.init(x: self.tabBar.center.x - 20, y: self.view.bounds.height - 47.5, width: 45, height: 45)
        button.layer.cornerRadius = 10
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Subviews Build
    
    func buildCreatePostButton() {
        button.setTitle("Like", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.yellow, for: .highlighted)
        //button.frame = CGRect(x: 100, y: 0, width: 44, height: 44)
        button.backgroundColor = .blue
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(white: 0.0, alpha: 1.0).cgColor
        button.addTarget(self, action: #selector(createPostSpaceView), for: .touchUpInside)
        self.view.insertSubview(button, aboveSubview: self.tabBar)
    }
    
    func buildPostSpaceView() {
        postSpaceView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        postSpaceView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        
        buildPostView()
        
        self.view.addSubview(postSpaceView!)
    }
    
    func buildExitPostSpaceView() {
        let exitButton = UIButton(frame: CGRect(x: 20, y: 20, width: 150, height: 30))
        exitButton.setTitle("Exit View", for: .normal)
        exitButton.addTarget(self, action: #selector(removePost), for: .touchUpInside)
        postSpaceView?.addSubview(exitButton)
    }
    
    func buildEnterPostButton() {
        let enterPostButton = UIButton(frame: CGRect(x: 200, y: 20, width: 150, height: 30))
        enterPostButton.setTitle("Enter Post", for: .normal)
        enterPostButton.addTarget(self, action: #selector(enterPost), for: .touchUpInside)
        postSpaceView?.addSubview(enterPostButton)
    }
    
    func buildPostView() {
        let postView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 50, height: 250))
        postView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        postView.center = CGPoint(x: UIScreen.main.bounds.maxX/2, y: UIScreen.main.bounds.maxY - 150)
        
        postMessageTextView = UITextView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 70, height: 150))
        //postMessageTextField.textColor = UIColor.white
        postMessageTextView?.backgroundColor = UIColor.white
        postView.addSubview(postMessageTextView!)
        postMessageTextView?.font = UIFont(name: "arial", size: 18)
        
        postSpaceView?.addSubview(postView)
    }
    
    
    
    // MARK: - Button Handlers
    
    @objc func createPostSpaceView(button: UIButton) {
        buildPostSpaceView()
        buildExitPostSpaceView()
        buildEnterPostButton()
    }
    
    @objc func enterPost(button: UIButton) {
        enterPostIntoFirebaseDatabase()
        postSpaceView?.removeFromSuperview()
    }
    
    @objc func removePost(button: UIButton) {
        postSpaceView?.removeFromSuperview()
    }
    
    
    // MARK: - Firebase Call Methods
    
    func enterPostIntoFirebaseDatabase() {
        let userID = Auth.auth().currentUser!.uid
        print(userID)
        
        ref.child("users").child(userID).observeSingleEvent(of: .value) { (snapshot) in
            if ( snapshot.value is NSNull ) {
                print("not found")
            } else {
                
                let dict = snapshot.value as? [String: Any]
                
                let name = dict!["name"] as! String
                let username = dict!["username"] as! String
                
                let data: Dictionary<String, Any> = ["postMessage": self.postMessageTextView!.text, "name":name, "username":username, "dateCreated":Date().timeIntervalSince1970] // Call date using "var date = NSDate(timeIntervalSince1970: interval)"
                self.ref.child("posts").childByAutoId().setValue(data)
            }
        }
    }
    
    
    // MARK: - Other Methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        postSpaceView?.endEditing(true)
    }
    
}
