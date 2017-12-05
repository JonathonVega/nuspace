//
//  CreateEventVC.swift
//  nuspace
//
//  Created by Jonathon F Vega on 11/24/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CreateEventVC: UIViewController {
    
    var ref: DatabaseReference!

    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventLocationTextField: UITextField!
    @IBOutlet weak var eventTimeTextField: UITextField!
    @IBOutlet weak var eventDescriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ref = Database.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func eventTimeTextFieldEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.full
        dateFormatter.timeStyle = DateFormatter.Style.none
        eventTimeTextField.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func createEvent(_ sender: Any) {
        let eventName = eventNameTextField.text
        let eventLocation = eventLocationTextField.text
        let eventRef = self.ref.child("events").childByAutoId()
        let eventRandomKey = eventRef.key
        
        print(eventRandomKey)
        let userID = Auth.auth().currentUser!.uid
        
        let data: Dictionary<String, Any> = ["CreatorKey":userID, "EventName": eventName!, "EventLocation": eventLocation!, "dateCreated":Date().timeIntervalSince1970] // Call date using "var date = NSDate(timeIntervalSince1970: interval)"
        self.ref.child("events").child(eventRandomKey).setValue(data)
        
        self.ref.child("users").child(userID).child("events").child(eventRandomKey).setValue(eventName!)
        
        print("Should have gone to firebase")
        // IDK why this is here. Figure out later
        //self.performSegue(withIdentifier: "loginSegue", sender: self)
        
        dismiss(animated: true, completion: nil)
    }

}
