//
//  LoginVC.swift
//  nuspace
//
//  Created by Jonathon F Vega on 11/15/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    var loginView: UIView?
    var emailLoginTextField: UITextField?
    var passwordLoginTextField: UITextField?
    
    var registerView: UIView?
    var registerImage: UIImage?
    var registerNameTextField: UITextField?
    var registerUsernameTextField: UITextField?
    var emailRegisterTextField: UITextField?
    var passwordRegisterTextField: UITextField?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * 2, height: scrollView.bounds.size.height)
        scrollView.isPagingEnabled = true
        setupLogin()
        setupRegister()
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleTap))
        tap.delegate = self as? UIGestureRecognizerDelegate
        self.view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupLogin() {
        loginView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.height - 300))
        loginView?.backgroundColor = UIColor.lightGray
        loginView?.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        
        emailLoginTextField = UITextField(frame: CGRect(x: 0, y: 0, width: (loginView?.frame.width)! - 20, height: 30))
        emailLoginTextField?.placeholder = "Email"
        emailLoginTextField?.center = CGPoint(x: (loginView?.bounds.width)!/2, y: ((loginView?.bounds.height)!/2) - 20)
        emailLoginTextField?.layer.borderWidth = 1.0
        emailLoginTextField?.layer.borderColor = UIColor.darkGray.cgColor
        emailLoginTextField?.layer.cornerRadius = 10
        loginView?.addSubview(emailLoginTextField!)
        emailLoginTextField?.delegate = self
        
        passwordLoginTextField = UITextField(frame: CGRect(x: 0, y: 0, width: (loginView?.frame.width)! - 20, height: 30))
        passwordLoginTextField?.placeholder = "Password"
        passwordLoginTextField?.center = CGPoint(x: (loginView?.bounds.width)!/2, y: ((loginView?.bounds.height)!/2) + 20)
        passwordLoginTextField?.layer.borderWidth = 1.0
        passwordLoginTextField?.layer.borderColor = UIColor.darkGray.cgColor
        passwordLoginTextField?.layer.cornerRadius = 10
        loginView?.addSubview(passwordLoginTextField!)
        passwordLoginTextField?.delegate = self
        
        scrollView.addSubview(loginView!)
        
    }
    
    func setupRegister() {
        registerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.height - 300))
        registerView?.backgroundColor = UIColor.lightGray
        registerView?.center = CGPoint(x: UIScreen.main.bounds.width/2 + UIScreen.main.bounds.width, y: UIScreen.main.bounds.height/2)
        
        // registerNameTextField
        registerNameTextField = UITextField(frame: CGRect(x: 0, y: 0, width: (loginView?.frame.width)! - 20, height: 30))
        registerNameTextField?.placeholder = "Email"
        registerNameTextField?.center = CGPoint(x: (loginView?.bounds.width)!/2, y: ((loginView?.bounds.height)!/2) - 20)
        registerNameTextField?.layer.borderWidth = 1.0
        registerNameTextField?.layer.borderColor = UIColor.darkGray.cgColor
        registerNameTextField?.layer.cornerRadius = 10
        registerView?.addSubview(registerNameTextField!)
        registerNameTextField?.delegate = self
        
        // registerUsernameTextField
        registerUsernameTextField = UITextField(frame: CGRect(x: 0, y: 0, width: (loginView?.frame.width)! - 20, height: 30))
        registerUsernameTextField?.placeholder = "Email"
        registerUsernameTextField?.center = CGPoint(x: (loginView?.bounds.width)!/2, y: ((loginView?.bounds.height)!/2) + 20)
        registerUsernameTextField?.layer.borderWidth = 1.0
        registerUsernameTextField?.layer.borderColor = UIColor.darkGray.cgColor
        registerUsernameTextField?.layer.cornerRadius = 10
        registerView?.addSubview(registerUsernameTextField!)
        registerUsernameTextField?.delegate = self
        
        scrollView.addSubview(registerView!)
    }
    
    // MARK: - Dismiss Keyboard
    
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer) {
        emailLoginTextField?.resignFirstResponder()
        passwordLoginTextField?.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailLoginTextField?.resignFirstResponder()
        passwordLoginTextField?.resignFirstResponder()
        return true
    }

}
