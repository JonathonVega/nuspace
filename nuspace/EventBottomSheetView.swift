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
    
    init(event: Event){
        self.event = event
        let screenSize = UIScreen.main.bounds
        let tabBarHeight:CGFloat = 49.0
        super.init(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - (tabBarHeight + 100), width: screenSize.width, height: screenSize.height))
        
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGesture(recognizer:))))
        //let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture))
        //self.addGestureRecognizer(gesture)
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
        let eventTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 21))
        eventTitle.center = CGPoint(x: 150, y: 10)
        eventTitle.textAlignment = .left
        eventTitle.text = "Event: " + (event?.title)!
        self.addSubview(eventTitle)
        
        let eventLocation = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 21))
        eventLocation.center = CGPoint(x: 150, y: 30)
        eventLocation.textAlignment = .left
        eventLocation.text = "Location: " + (event?.locationName)!
        self.addSubview(eventLocation)
    }
    
    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self)
        let y = self.frame.minY
        self.frame = CGRect(x: 0, y: y + translation.y, width: self.frame.width, height: self.frame.height)
        recognizer.setTranslation(CGPoint.zero, in: self)
        
        if recognizer.state == .began {
            startPosition = self.center
        } else if recognizer.state == .changed {
            let translation = recognizer.translation(in: self)
            guard let start = self.startPosition else { return }
            let newCenter = CGPoint(x: start.x + translation.x , y: start.y + translation.y)
            //let newCenter = CGPoint(x: start.x + translation.x, y: x.y + translation.y)
            self.center = newCenter
        } else {
            startPosition = nil
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
