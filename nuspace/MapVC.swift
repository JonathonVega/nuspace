//
//  MapVC.swift
//  nuspace
//
//  Created by Jonathon F Vega on 10/19/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase

class ImageAnnotationView: MKAnnotationView {
    private var imageView: UIImageView!
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?){
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.addSubview(self.imageView)
        
        self.imageView.layer.cornerRadius = 25.0
        self.imageView.layer.masksToBounds = true
    }
    
    override var image: UIImage? {
        get {
            return self.imageView.image
        }
        set{
            self.imageView.image = newValue
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MapVC: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 440, height: 40))
    
    var myLocationLatitude:CLLocationDegrees?
    var myLocationLongitude: CLLocationDegrees?
    var appJustOpened = true
    var distance: Int = 10
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        self.mapView?.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        
        searchBar.placeholder = "Search for Places"
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar // or use self.navigationcontroller.topItem?.titleView = searchBar
        
        updateMapWithAnnotations()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateMapWithAnnotations() {
        ref.child("Events").observe(.value) { (snapshot) in
            if ( snapshot.value is NSNull ) {
                print("not found")
            } else {
                
                for child in (snapshot.children) {
                    
                    let snap = child as! DataSnapshot //each child is a snapshot
                    let dict = snap.value as! [String: Any] // the value is a dict
                    
                    let title = dict["Title"] as! String
                    let locationName = dict["LocationName"] as! String
                    let longitude = dict["Longitude"] as! Double
                    let latitude = dict["Latitude"] as! Double
                    
                    let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    
                    let annotation = Venue(title: title, locationName: locationName, coordinate: location)
                    
                    self.mapView.addAnnotation(annotation)
                    
                    print("\(title) will be at \(locationName)") // Set new rules later in firebase: "auth != null"
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        //let flocaito = locations.first
        myLocationLatitude = location.coordinate.latitude
        myLocationLongitude = location.coordinate.longitude
        
        if appJustOpened == true {
            let span: MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
            let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
            mapView.setRegion(region, animated: false)
            appJustOpened = false
        }
        
        print(mapView.region)
        
        mapView.showsUserLocation = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.searchBar.endEditing(true)
    }
}


extension MapVC: MKMapViewDelegate {
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Venue") //?? ImageAnnotationView()
        annotationView = ImageAnnotationView(annotation: annotation, reuseIdentifier: "Venue")
        let customAnnotation = annotation as! Venue
        annotationView?.image = customAnnotation.image//UIImage(named: "landscape")
        annotationView?.canShowCallout = true
        annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        return annotationView
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            performSegue(withIdentifier: "toEventPage", sender: self)
        }
    }
    
    
    
}


