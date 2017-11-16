//
//  LoginVC.swift
//  nuspace
//
//  Created by Jonathon F Vega on 11/15/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginVC: UIViewController, UITextFieldDelegate {
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var loginView: UIView?
    var loginEmailTextField: UITextField?
    var loginPasswordTextField: UITextField?
    
    var registerView: UIView?
    var registerImage: UIImage?
    var registerNameTextField: UITextField?
    var registerUsernameTextField: UITextField?
    var registerEmailTextField: UITextField?
    var registerPasswordTextField: UITextField?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ref = Database.database().reference()
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * 2, height: scrollView.bounds.size.height)
        scrollView.isPagingEnabled = true
        setupLoginView()
        setupRegisterView()
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleTap))
        tap.delegate = self as? UIGestureRecognizerDelegate
        self.view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Views Setup
    
    func setupLoginView() {
        loginView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.height - 300))
        loginView?.backgroundColor = UIColor.lightGray
        loginView?.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        
        loginEmailTextField = UITextField(frame: CGRect(x: 0, y: 0, width: (loginView?.frame.width)! - 20, height: 30))
        loginEmailTextField?.placeholder = "Email"
        loginEmailTextField?.center = CGPoint(x: (loginView?.bounds.width)!/2, y: ((loginView?.bounds.height)!/2) - 20)
        loginEmailTextField?.layer.borderWidth = 1.0
        loginEmailTextField?.layer.borderColor = UIColor.darkGray.cgColor
        loginEmailTextField?.layer.cornerRadius = 10
        loginView?.addSubview(loginEmailTextField!)
        loginEmailTextField?.delegate = self
        
        loginPasswordTextField = UITextField(frame: CGRect(x: 0, y: 0, width: (loginView?.frame.width)! - 20, height: 30))
        loginPasswordTextField?.placeholder = "Password"
        loginPasswordTextField?.center = CGPoint(x: (loginView?.bounds.width)!/2, y: ((loginView?.bounds.height)!/2) + 20)
        loginPasswordTextField?.layer.borderWidth = 1.0
        loginPasswordTextField?.layer.borderColor = UIColor.darkGray.cgColor
        loginPasswordTextField?.layer.cornerRadius = 10
        loginView?.addSubview(loginPasswordTextField!)
        loginPasswordTextField?.delegate = self
        
        let loginButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        loginButton.titleLabel?.text = "Login"
        loginButton.backgroundColor = UIColor.blue
        loginButton.center = CGPoint(x: loginView!.bounds.width/2, y: loginView!.bounds.maxY - 100)
        loginButton.addTarget(self, action: #selector(loginUser), for: .touchUpInside)
        loginView?.addSubview(loginButton)
        
        scrollView.addSubview(loginView!)
    }
    
    func setupRegisterView() {
        registerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.height - 300))
        registerView?.backgroundColor = UIColor.lightGray
        registerView?.center = CGPoint(x: UIScreen.main.bounds.width/2 + UIScreen.main.bounds.width, y: UIScreen.main.bounds.height/2)
        
        // registerNameTextField
        registerNameTextField = UITextField(frame: CGRect(x: 0, y: 0, width: (loginView?.frame.width)! - 20, height: 30))
        registerNameTextField?.placeholder = "Name"
        registerNameTextField?.center = CGPoint(x: (loginView?.bounds.width)!/2, y: ((loginView?.bounds.height)!/2) - 60)
        registerNameTextField?.layer.borderWidth = 1.0
        registerNameTextField?.layer.borderColor = UIColor.darkGray.cgColor
        registerNameTextField?.layer.cornerRadius = 10
        registerView?.addSubview(registerNameTextField!)
        registerNameTextField?.delegate = self
        
        // registerUsernameTextField
        registerUsernameTextField = UITextField(frame: CGRect(x: 0, y: 0, width: (loginView?.frame.width)! - 20, height: 30))
        registerUsernameTextField?.placeholder = "Username"
        registerUsernameTextField?.center = CGPoint(x: (loginView?.bounds.width)!/2, y: ((loginView?.bounds.height)!/2) - 20)
        registerUsernameTextField?.layer.borderWidth = 1.0
        registerUsernameTextField?.layer.borderColor = UIColor.darkGray.cgColor
        registerUsernameTextField?.layer.cornerRadius = 10
        registerView?.addSubview(registerUsernameTextField!)
        registerUsernameTextField?.delegate = self
        
        // emailRegisterTextField
        registerEmailTextField = UITextField(frame: CGRect(x: 0, y: 0, width: (loginView?.frame.width)! - 20, height: 30))
        registerEmailTextField?.placeholder = "Email"
        registerEmailTextField?.center = CGPoint(x: (loginView?.bounds.width)!/2, y: ((loginView?.bounds.height)!/2) + 20)
        registerEmailTextField?.layer.borderWidth = 1.0
        registerEmailTextField?.layer.borderColor = UIColor.darkGray.cgColor
        registerEmailTextField?.layer.cornerRadius = 10
        registerView?.addSubview(registerEmailTextField!)
        registerEmailTextField?.delegate = self
        
        // passwordRegisterTextField
        registerPasswordTextField = UITextField(frame: CGRect(x: 0, y: 0, width: (loginView?.frame.width)! - 20, height: 30))
        registerPasswordTextField?.placeholder = "Password"
        registerPasswordTextField?.center = CGPoint(x: (loginView?.bounds.width)!/2, y: ((loginView?.bounds.height)!/2) + 60)
        registerPasswordTextField?.layer.borderWidth = 1.0
        registerPasswordTextField?.layer.borderColor = UIColor.darkGray.cgColor
        registerPasswordTextField?.layer.cornerRadius = 10
        registerView?.addSubview(registerPasswordTextField!)
        registerPasswordTextField?.delegate = self
        
        let registerButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        registerButton.titleLabel?.text = "Login"
        registerButton.backgroundColor = UIColor.blue
        registerButton.center = CGPoint(x: registerView!.bounds.width/2, y: registerView!.bounds.maxY - 100)
        registerButton.addTarget(self, action: #selector(registerUser), for: .touchUpInside)
        registerView?.addSubview(registerButton)
        
        scrollView.addSubview(registerView!)
    }
    
    
    // MARK: - Button Actions
    
    @objc func loginUser(button: UIButton) {
        loginUserFromFirebase()
        performSegue(withIdentifier: "loginSegue", sender: self)
    }
    
    @objc func registerUser(button: UIButton) {
        registerUserToFirebase()
        performSegue(withIdentifier: "loginSegue", sender: self)
    }
    
    
    // MARK: - Firebase Call Methods
    
    func loginUserFromFirebase() {
        if let email=loginEmailTextField?.text, let password=loginPasswordTextField?.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if user != nil {
                    print(user!.uid)
                }
                else {
                    
                    if let errCode = AuthErrorCode(rawValue: (error! as NSError).code){
                        
                        // TODO: Need to fix errors through UI accordingly
                        switch errCode {
                        case .invalidEmail:
                            print("Invalid email")
                        case .wrongPassword:
                            print("Password is wrong")
                        case .userDisabled:
                            print("User account is disabled")
                        case .userNotFound:
                            print("User account cannot be found")
                        default:
                            print("Wrong in some way!!!")
                        }
                    }
                    
                    print(error!)
                    
                }
            })
        }
    }
    
    func registerUserToFirebase() {
        if let email=registerEmailTextField?.text, let password=registerPasswordTextField?.text, let name=registerNameTextField?.text, let username=registerUsernameTextField?.text {
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if user != nil {
                    
                    let data: Dictionary<String, Any> = ["email": email, "password": password, "name": name, "username":username, "dateCreated":Date().timeIntervalSince1970]
                    Database.database().reference().child("users").child(user!.uid).setValue(data)
                    
                    
                } else {
                    
                    if let errCode = AuthErrorCode(rawValue: (error! as NSError).code){
                        
                        // TODO: Need to fix errors through UI accordingly
                        switch errCode {
                        case .invalidEmail:
                            print("Invalid email")
                        case .emailAlreadyInUse:
                            print("Email already in use")
                        case .weakPassword:
                            print("Password is weak")
                        default:
                            print("Wrong in some way!!!")
                        }
                    }
                    
                    print(error!)
                    
                }
            })
        }
    }
    
    
    // MARK: - Dismiss Keyboard
    
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer) {
        loginEmailTextField?.resignFirstResponder()
        loginPasswordTextField?.resignFirstResponder()
        registerNameTextField?.resignFirstResponder()
        registerUsernameTextField?.resignFirstResponder()
        registerEmailTextField?.resignFirstResponder()
        registerPasswordTextField?.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        loginEmailTextField?.resignFirstResponder()
        loginPasswordTextField?.resignFirstResponder()
        registerNameTextField?.resignFirstResponder()
        registerUsernameTextField?.resignFirstResponder()
        registerEmailTextField?.resignFirstResponder()
        registerPasswordTextField?.resignFirstResponder()
        return true
    }

}
