//
//  TabBarController.swift
//  nuspace
//
//  Created by Jonathon F Vega on 10/19/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    let button = UIButton.init(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        button.setTitle("Like", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.yellow, for: .highlighted)
        //button.frame = CGRect(x: 100, y: 0, width: 44, height: 44)
        button.backgroundColor = .blue
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(white: 0.0, alpha: 1.0).cgColor
        self.view.insertSubview(button, aboveSubview: self.tabBar)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.frame = CGRect.init(x: self.tabBar.center.x - 40, y: self.view.bounds.height - 50, width: 80, height: 50)
        button.layer.cornerRadius = 10
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
