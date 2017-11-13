//
//  ListVC.swift
//  nuspace
//
//  Created by Jonathon F Vega on 10/21/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseDatabase

class ListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var onActivity = true // true for activity, false for discover
    
    var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 440, height: 40))
    
    //var activityArray:
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ref = Database.database().reference()
        
        searchBar.placeholder = "Search"
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        
        self.tableView.keyboardDismissMode = .onDrag
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post", for: indexPath)
        
        // Configure the cell...
        
        return cell
    }
    
    func getDataFromFirebase() {
        ref.child("Events").observeSingleEvent(of: .value) { (snapshot) in
            if ( snapshot.value is NSNull ) {
                print("not found")
            } else {
                
                for child in (snapshot.children) {
                    
                    let snap = child as! DataSnapshot //each child is a snapshot
                    let dict = snap.value as! [String: Any] // the value is a dict
                    
                    let title = dict["EventTitle"] as! String
                    let locationName = dict["EventLocation"] as! String
                    let eventDescription = dict["EventDescription"] as! String
                    let longitude = dict["Longitude"] as! Double
                    let latitude = dict["Latitude"] as! Double
                    
                    let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    
                    
                    let event = Event(title: title, locationName: locationName, eventDescription: eventDescription, coordinate: location)
                    print(title)
                }
            }
        }
    }
}
