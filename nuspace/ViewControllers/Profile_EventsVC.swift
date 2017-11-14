//
//  Profile_EventsVC.swift
//  nuspace
//
//  Created by Jonathon F Vega on 11/13/17.
//  Copyright © 2017 Jonathon Vega. All rights reserved.
//

import UIKit

class Profile_EventsVC: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var organizationsView: UIView!
    @IBOutlet weak var eventsTableView: UITableView!
    
    let screenHeight = UIScreen.main.bounds.height//UIScreen.main.Screen().bounds.height
    let scrollViewContentHeight = 900 as CGFloat
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: 787)//scrollViewContentHeight)
        scrollView.delegate = self
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        scrollView.bounces = false
        eventsTableView.bounces = false
        eventsTableView.isScrollEnabled = false
        //eventsTableView.frame = CGRect(x: 0, y: eventsTableView.frame.minY, width: eventsTableView.frame.width, height: eventsTableView.contentSize.height)
        eventsTableView.frame = CGRect(x: 0, y: eventsTableView.frame.minY, width: eventsTableView.frame.width, height: screenHeight - 146)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        print(yOffset)
        if scrollView == self.scrollView {
            if yOffset > 0 {//yOffset >= scrollViewContentHeight - screenHeight {
                print("hit")
                print(scrollViewContentHeight - screenHeight)
                //scrollView.isScrollEnabled = false
                //eventsTableView.isScrollEnabled = true
                
                eventsTableView.frame = CGRect(x: 0, y: eventsTableView.frame.minY, width: eventsTableView.frame.width, height: eventsTableView.contentSize.height)
                self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: eventsTableView.frame.minY + eventsTableView.frame.height)//CGRect(x: 0, y: 0, width: self.scrollView.frame.width, height: eventsTableView.frame.minY + eventsTableView.frame.height)
            }
        }
        
        /*if scrollView == self.eventsTableView {
            if yOffset == 0 {
                self.scrollView.isScrollEnabled = true
                self.eventsTableView.isScrollEnabled = false
            }
        }*/
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        // Configure the cell...
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
