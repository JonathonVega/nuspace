//
//  Event.swift
//  nuspace
//
//  Created by Jonathon F Vega on 10/19/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import MapKit

class Event: NSObject, MKAnnotation {
    var title: String?
    var locationName: String?
    var coordinate: CLLocationCoordinate2D
    var image: UIImage?
    
    init(title: String, locationName: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        self.image = UIImage(named: "landscape")
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
}
