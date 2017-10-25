//
//  DistantAnnotationView.swift
//  nuspace
//
//  Created by Jonathon F Vega on 10/24/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class DistantAnnotationView: MKAnnotationView {
    var imageView: UIImageView!
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?){
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        self.imageView = UIImageView(frame: CGRect(x: -20, y: -20, width: 50, height: 50))
        self.imageView.alpha = 0.0
        self.addSubview(self.imageView)
        self.imageView.layer.cornerRadius = 25.0
        self.imageView.layer.masksToBounds = true
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.layer.cornerRadius = 5
        //self.layer.masksToBounds = true
    }
    
    override var image: UIImage? {
        get {
            return self.imageView.image
        } set {
            self.imageView.image = newValue
        }
    }
    
    func showImage() {
        imageView.alpha = 1.0
        layer.borderWidth = 0
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        frame.size = CGSize(width: 50, height: 50)
        frame.origin = CGPoint(x: frame.origin.x - 20, y: frame.origin.y - 20)
        
    }
    
    func hideImage() {
        imageView.alpha = 0.0
        layer.borderWidth = 1
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        imageView.frame = CGRect(x: -20, y: -20, width: 50, height: 50)
        frame.origin = CGPoint(x: frame.origin.x + 20, y: frame.origin.y + 20)
        frame.size = CGSize(width: 10, height: 10)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
