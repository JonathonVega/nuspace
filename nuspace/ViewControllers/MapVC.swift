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

class MapVC: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, MKMapViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
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
        
        var annotationsArray = [Event]()
        ref.child("Events").observe(.value) { (snapshot) in
            print("Does it go through here")
            self.mapView.removeAnnotations(self.mapAnnotations)
            if ( snapshot.value is NSNull ) {
                print("not found")
            } else {
                
                for child in (snapshot.children) {
                    
                    let snap = child as! DataSnapshot //each child is a snapshot
                    let dict = snap.value as! [String: Any] // the value is a dict
                    
                    let title = dict["EventTitle"] as! String
                    let locationName = dict["EventLocation"] as! String
                    let longitude = dict["Longitude"] as! Double
                    let latitude = dict["Latitude"] as! Double
                    
                    let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    
                    let annotation = Event(title: title, locationName: locationName, coordinate: location)
                    annotationsArray.append(annotation)
                    //print("\(title) will be at \(locationName)") // Set new rules later in firebase: "auth != null"
                }
            }
            print(annotationsArray)
            print(self.mapAnnotations)
            
            for annotation in annotationsArray {
                print(self.mapAnnotations.contains(annotation))
                if !self.mapAnnotations.contains(annotation) {
                    //self.mapView.addAnnotations(annotationsArray)
                    self.mapView.addAnnotation(annotation)
                }
            }
            
            self.mapAnnotations = annotationsArray
            annotationsArray.removeAll()
        }
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
    
    
    // MARK: - Other Methods
    
    // Exit SearchBar Keyboard when touching screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.searchBar.endEditing(true)
    }
    
}

