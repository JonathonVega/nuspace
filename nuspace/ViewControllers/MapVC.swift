//
//  MapVC.swift
//  nuspace
//
//  Created by Jonathon F Vega on 10/19/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//



// TODO:
// Need to set new rules later in firebase: "auth != null"

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase

class MapVC: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, MKMapViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var bottomSheet: UIView!
    
    let locationManager = CLLocationManager()
    var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 440, height: 40))
    
    var myLocationLatitude:CLLocationDegrees?
    var myLocationLongitude: CLLocationDegrees?
    var appJustOpened = true
    var distance: Int = 10
    
    var ref: DatabaseReference!
    
    var mapAnnotations: [Event] = []
    var bottomEventView: EventBottomSheetView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        self.mapView?.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        
        //searchController.searchBar.frame(CGRect(x: 0, y: 0, width: 440, height: 40))
        
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
        //let allAnnotations = self.mapView.annotations
        fillMapViewWithAnnotationsFromFirebase()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        myLocationLatitude = location.coordinate.latitude
        myLocationLongitude = location.coordinate.longitude
        
        if appJustOpened == true {
            let span: MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
            let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
            mapView.setRegion(region, animated: false)
            appJustOpened = false
        }
        
        //print(mapView.region)
        
        mapView.showsUserLocation = true
    }
    
    
    // MARK: - MapView Delegate

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        } else if (annotation as! Event).isDistant {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Event")
            annotationView = DistantAnnotationView(annotation: annotation, reuseIdentifier: "Event")
            let customAnnotation = annotation as! Event
            annotationView?.image = customAnnotation.image
            annotationView?.canShowCallout = false
            annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return annotationView
        } else {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Event")
            annotationView = ImageAnnotationView(annotation: annotation, reuseIdentifier: "Event")
            let customAnnotation = annotation as! Event
            annotationView?.image = customAnnotation.image
            annotationView?.canShowCallout = false
            annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return annotationView
        }
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            performSegue(withIdentifier: "toEventPage", sender: self)
        }
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        // Disable touch on userLocation Annotation
        if let currentUser: MKAnnotationView = mapView.view(for: mapView.userLocation) {
            currentUser.isEnabled = false
        }
        
    }
    
    // Change annotation views when zoomed in or out
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if mapView.region.span.latitudeDelta <= 0.015 {
            for eventAnnotation in mapView.annotations {
                if eventAnnotation is MKUserLocation {
                    continue
                } else if !(eventAnnotation as! Event).isDistant{
                    break
                }
                if mapView.selectedAnnotations.isEmpty {
                    mapView.removeAnnotation(eventAnnotation)
                    (eventAnnotation as! Event).isDistant = false
                    mapView.addAnnotation(eventAnnotation)
                } else {
                    let selectedAnnotation = mapView.selectedAnnotations.first
                    mapView.removeAnnotation(eventAnnotation)
                    (eventAnnotation as! Event).isDistant = false
                    mapView.addAnnotation(eventAnnotation)
                    if (selectedAnnotation as! Event) == (eventAnnotation as! Event) {
                        mapView.selectAnnotation(eventAnnotation, animated: false)
                    }
                }
            }
        } else if mapView.region.span.latitudeDelta > 0.015 {
            for eventAnnotation in mapView.annotations {
                if eventAnnotation is MKUserLocation {
                    continue
                } else if (eventAnnotation as! Event).isDistant{
                    break
                }
                if mapView.selectedAnnotations.isEmpty {
                    mapView.removeAnnotation(eventAnnotation)
                    (eventAnnotation as! Event).isDistant = true
                    mapView.addAnnotation(eventAnnotation)
                } else {
                    let selectedAnnotation = mapView.selectedAnnotations.first
                    mapView.removeAnnotation(eventAnnotation)
                    (eventAnnotation as! Event).isDistant = true
                    mapView.addAnnotation(eventAnnotation)
                    if (selectedAnnotation as! Event) == (eventAnnotation as! Event) {
                        mapView.selectAnnotation(eventAnnotation, animated: false)
                    }
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view is DistantAnnotationView {
            let selectedView = view as! DistantAnnotationView
            selectedView.hideImage()
        }
        bottomEventView?.removeFromSuperview()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view is DistantAnnotationView {
            let selectedView = view as! DistantAnnotationView
            selectedView.showImage()
        }
        let chosenEvent = view.annotation as! Event
        addBottomSheetView(event: chosenEvent)
    }

    
    // MARK: - Event Detail Bottom Sheet
    
    func addBottomSheetView(event: Event) {
        // 1- Init bottomSheetVC
        
        bottomEventView = EventBottomSheetView(event: event)
        
        // 2- Add bottomSheetVC as a child view
        self.view.addSubview((bottomEventView)!)
        
        // 3- Adjust bottomSheet frame and initial position.
        //let height = view.frame.height
        //let width  = view.frame.width
        //bottomEventView?.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
    }
    
    
    // MARK: - Firebase Call Methods
    
    // Used to fill the mapAnnotation's global array AND fill in the map with those annotations
    func fillMapViewWithAnnotationsFromFirebase() {
        var annotationsArray = [Event]()
        ref.child("Events").observeSingleEvent(of: .value) { (snapshot) in
            self.mapView.removeAnnotations(self.mapView.annotations)
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
                    
                    if self.isCoordinateInsideRegion(region: self.mapView.region, coordinate: location) {
                        let annotation = Event(title: title, locationName: locationName, eventDescription: eventDescription, coordinate: location)
                        self.mapView.addAnnotation(annotation)
                        annotationsArray.append(annotation)
                    }
                    //print("\(title) will be at \(locationName)") // Set new rules later in firebase: "auth != null"
                }
                self.mapAnnotations = annotationsArray
                annotationsArray.removeAll()
            }
        }
    }
    
    // Use to filter data through searchBar
    func getFilteredAnnotations(searchText: String) {
        var filteredData = [Event]()
        self.mapView.removeAnnotations(self.mapView.annotations)
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
                    
                    if self.isCoordinateInsideRegion(region: self.mapView.region, coordinate: location) && ((title.lowercased().range(of: searchText) != nil) || ((locationName.lowercased().range(of: searchText) != nil))){
                        let annotation = Event(title: title, locationName: locationName, eventDescription: eventDescription, coordinate: location)
                        print(title)
                        filteredData.append(annotation)
                    }
                }
            }
            print("Filtered")
            print(filteredData)
            self.mapView.addAnnotations(filteredData)
        }
    }
    
    
    // MARK: - Search Bar
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // Activity Indicator
        /*let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()*/
        
        // Hide search bar
        self.searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        // Filter through data
        let searchText = searchBar.text?.lowercased()
        getFilteredAnnotations(searchText: searchText!)
        print(mapAnnotations)
        print("Cool")
        
        //self.mapView.removeAnnotations(self.mapAnnotations)
        print("First")
        //print(mapView.annotations)
        print("Second")
    }
    
    // Exit SearchBar Keyboard when touching screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.searchBar.endEditing(true)
    }
    
    // MARK: - Other Methods
    
    @IBAction func refreshMap(_ sender: UIButton) {
        fillMapViewWithAnnotationsFromFirebase()
    }
    
    func isCoordinateInsideRegion(region: MKCoordinateRegion, coordinate: CLLocationCoordinate2D) -> Bool {
        let southEdge = region.center.latitude - (region.span.latitudeDelta/2)
        let northEdge = region.center.latitude + (region.span.latitudeDelta/2)
        let westEdge = region.center.longitude - (region.span.longitudeDelta/2)
        let eastEdge = region.center.longitude + (region.span.longitudeDelta/2)
        if southEdge <= coordinate.latitude && northEdge >= coordinate.latitude && westEdge <= coordinate.longitude && eastEdge >= coordinate.longitude {
            return true
        }
        return false
    }
    
}

