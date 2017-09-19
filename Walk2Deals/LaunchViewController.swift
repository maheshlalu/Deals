//
//  LaunchViewController.swift
//  realTimeProject
//
//  Created by veerabrahmam suthari on 17/9/17.
//  Copyright © 2017 veerabrahmam suthari. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    @IBOutlet weak var launchImage: UIImageView!
    @IBOutlet weak var launchLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        launchImage.image = UIImage(named: "logo")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func launchBtn(_ sender: UIButton) {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let enternumber : EnterMobileNumberViewController = (storyboard.instantiateViewController(withIdentifier: "EnterMN") as? EnterMobileNumberViewController)!
        self.navigationController?.pushViewController(enternumber, animated: true)
        
    }


}
