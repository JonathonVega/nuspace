//
//  Profile_EventsVC.swift
//  nuspace
//
//  Created by Jonathon F Vega on 11/13/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class Profile_EventsVC: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var databaseRef: DatabaseReference!
    var storage: Storage!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    
    @IBOutlet weak var organizationsView: UIView!
    @IBOutlet weak var eventsTableView: UITableView!
    
    let screenHeight = UIScreen.main.bounds.height//UIScreen.main.Screen().bounds.height
    let scrollViewContentHeight = 900 as CGFloat
    
    override func viewDidLoad() {
        super.viewDidLoad()

        databaseRef = Database.database().reference()
        storage = Storage.storage()
        
        // Do any additional setup after loading the view.
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: 787)//scrollViewContentHeight)
        scrollView.delegate = self
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        scrollView.bounces = false
        eventsTableView.bounces = false
        eventsTableView.isScrollEnabled = false
        print("Does it hit this?")
        getProfileDataFromFirebase()
        setupTapRecognizers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Changes scrollView size depending on size of tableView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        if scrollView == self.scrollView {
            if yOffset > 0 {//yOffset >= scrollViewContentHeight - screenHeight {
                //print("It hits this")
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        // Configure the cell...
        
        self.containerViewHeight.constant = eventsTableView.frame.minY + eventsTableView.contentSize.height // Adjusts height so eventsTable can be scrolled down
        
        return cell
    }
    
    
    // MARK: - Firebase Call Methods
    
    func getProfileDataFromFirebase() {
        let userID = Auth.auth().currentUser?.uid
        databaseRef.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            //print(value!)
            let name = value?["name"] as? String ?? ""
            //print(name)
            self.profileNameLabel.text = name
            if let image = value?["profileImage"] as? String {
                // TODO: Fill out later when working with Firebase Storage
                print("Nothing Should be coming out")
                print(image)
            } else {
                print("Oh no, no picture")
                //let defaultProfileImageRef = Storage.storage(url: "gs://nuspace-a5b5b.appspot.com/DefaultUserImage.png")
                let spaceRef = self.storage.reference(forURL: "gs://nuspace-a5b5b.appspot.com/DefaultUserImage.png")
                spaceRef.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                    if let error = error {
                        print(error)
                        // Uh-oh, an error occurred!
                    } else {
                        // Data for "images/island.jpg" is returned
                        self.profileImage.image = UIImage(data: data!)
                    }
                })

                // TODO: Fill out later when working with Firebase Storage
            }
        })
    }
    
    func getOrganizationsDataFromFirebase() {
        
    }
    
    func getEventsDataFromFirebase() {
        
    }
    
    
    //MARK: - Gesture Recognizers
    
    func setupTapRecognizers() {
        let profileTap = UITapGestureRecognizer.init(target: self, action: #selector(handleProfileTap))
        profileTap.delegate = self as? UIGestureRecognizerDelegate
        profileView.addGestureRecognizer(profileTap)
        
        let organizationsTap = UITapGestureRecognizer.init(target: self, action: #selector(handleOrganizationsTap))
        organizationsTap.delegate = self as? UIGestureRecognizerDelegate
        organizationsView.addGestureRecognizer(organizationsTap)
    }
    
    @objc func handleProfileTap(gestureRecognizer: UIGestureRecognizer) {
        performSegue(withIdentifier: "toMyProfileSegue", sender: self)
    }
    
    @objc func handleOrganizationsTap(gestureRecognizer: UIGestureRecognizer) {
        performSegue(withIdentifier: "toOrganizationsSegue", sender: self)
    }
    

    @IBAction func settingsButton(_ sender: Any) {
        performSegue(withIdentifier: "toSettingsSegue", sender: self)
    }
    
    @IBAction func addEvent(_ sender: Any) {
        performSegue(withIdentifier: "segueToCreateEvent", sender: self)
    }
    

}
