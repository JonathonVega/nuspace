//
//  EventBottomSheetVC.swift
//  nuspace
//
//  Created by Jonathon F Vega on 10/25/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import Foundation
import UIKit

class EventBottomSheetVC: UIViewController {
    
    var event: Event? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(EventBottomSheetVC.panGesture))
        view.addGestureRecognizer(gesture)
        
        prepareBackgroundView()
        insertEventDetails()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) { [weak self] in
            let frame = self?.view.frame
            let yComponent = UIScreen.main.bounds.height - 100
            self?.view.frame = CGRect(x: 0, y: yComponent, width: frame!.width, height: frame!.height)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareBackgroundView() {
        let blurEffect = UIBlurEffect.init(style: .regular)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.contentView.addSubview(visualEffect)
        
        visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds
        
        view.insertSubview(bluredView, at: 0)
    }
    
    func insertEventDetails() {
        let eventTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 21))
        eventTitle.center = CGPoint(x: 150, y: 10)
        eventTitle.textAlignment = .left
        eventTitle.text = "Event: " + (event?.title)!
        self.view.addSubview(eventTitle)
        
        let eventLocation = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 21))
        eventLocation.center = CGPoint(x: 150, y: 30)
        eventLocation.textAlignment = .left
        eventLocation.text = "Location: " + (event?.locationName)!
        self.view.addSubview(eventLocation)
    }
    
    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let y = self.view.frame.minY
        self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
    func hideView() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            let frame = self?.view.frame
            let yComponent = UIScreen.main.bounds.height
            self?.view.frame = CGRect(x: 0, y: yComponent, width: frame!.width, height: frame!.height)
        }
    }

}
