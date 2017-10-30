//
//  EventBottomSheetView.swift
//  nuspace
//
//  Created by Jonathon F Vega on 10/26/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import UIKit

class EventBottomSheetView: UIView {
    var event: Event?
    var startPosition: CGPoint?
    var fullView: CGFloat {
        return UIScreen.main.bounds.height - 200
    }
    var partialView: CGFloat {
        return UIScreen.main.bounds.height - 150
    }
    
    init(event: Event){
        self.event = event
        let screenSize = UIScreen.main.bounds
        let tabBarHeight:CGFloat = 49.0
        super.init(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - (tabBarHeight + 100), width: screenSize.width, height: 200))//screenSize.height))
        
        //self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGesture(recognizer:))))
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture))
        self.addGestureRecognizer(gesture)
        
        
        setupViewBackground()
        setupLayout()
    }
    func setupViewBackground() {
        let blurEffect = UIBlurEffect.init(style: .extraLight)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.contentView.addSubview(visualEffect)
        
        //visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds
        
        self.insertSubview(bluredView, at: 0)
        //self.backgroundColor = UIColor.white
    }
    
    func setupLayout(){
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
        
        // Add gripper to let user know that they can pan the view
        let gripper = UIView()
        self.addSubview(gripper)
        gripper.backgroundColor = UIColor.gray
        gripper.translatesAutoresizingMaskIntoConstraints = false
        gripper.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        gripper.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        //gripper.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true //centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        gripper.widthAnchor.constraint(equalToConstant: 36).isActive = true
        gripper.heightAnchor.constraint(equalToConstant: 5).isActive = true
        gripper.layer.cornerRadius = 2.5
        
        
        let eventTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 21))
        eventTitle.center = CGPoint(x: 150, y: 30)
        eventTitle.textAlignment = .left
        eventTitle.text = "Event: " + (event?.title)!
        self.addSubview(eventTitle)
        
        let eventLocation = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 21))
        eventLocation.center = CGPoint(x: 150, y: 50)
        eventLocation.textAlignment = .left
        eventLocation.text = "Location: " + (event?.locationName)!
        self.addSubview(eventLocation)
    }
    
    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self)
        let y = self.frame.minY
        //print(y)
        //self.frame = CGRect(x: 0, y: y + translation.y, width: self.frame.width, height: self.frame.height)

        let velocity = recognizer.velocity(in: self)

        if ( y + translation.y >= fullView) && (y + translation.y <= partialView) {
            print(translation.y + y)
            self.frame = CGRect(x: 0, y: y + translation.y, width: self.frame.width, height: self.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self)
        }
            
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.frame = CGRect(x: 0, y: self.partialView, width: self.frame.width, height: self.frame.height)
                } else {
                    self.frame = CGRect(x: 0, y: self.fullView, width: self.frame.width, height: self.frame.height)
                }
                
            }, completion: nil)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
