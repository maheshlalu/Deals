//
//  LaunchViewController.swift
//  realTimeProject
//
//  Created by veerabrahmam suthari on 17/9/17.
//  Copyright © 2017 veerabrahmam suthari. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    @IBOutlet weak var dealsBtn: UIButton!

    @IBOutlet weak var launchBtn: UIButton!
    @IBOutlet weak var launchImage: UIImageView!
    @IBOutlet weak var launchLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        launchImage.image = UIImage(named: "logo")
        self.dealsBtn.isHidden = true
        self.addSwipeGestures()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
    }
    
    func addSwipeGestures(){
    
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeRightGesture))
        
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeLeftGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
       
    }
    
    func respondToSwipeRightGesture(gesture: UIGestureRecognizer) {
        
        
    }
    
    func respondToSwipeLeftGesture(gesture: UIGestureRecognizer) {
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    

    @IBAction func launchBtn(_ sender: UIButton) {
        self.dealsBtn.isHidden = false
        self.launchBtn.isHidden = true
        self.launchLbl.text = "Don't My Your Great Deals!"
    }

    @IBAction func dealsBtnAction(_ sender: UIButton) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let enternumber : EnterMobileNumberViewController = (storyboard.instantiateViewController(withIdentifier: "EnterMN") as? EnterMobileNumberViewController)!
        self.navigationController?.pushViewController(enternumber, animated: true)
    }

}
