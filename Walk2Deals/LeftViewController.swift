//
//  LeftViewController.swift
//  Walk2Deals
//
//  Created by apple on 23/09/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LeftViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var leftTableview: UITableView!
    var nameArray = ["Home","Near By Stours","My Deals","Rewards Points","Favourites","Invite your friends","Settings","Give us Feedback","Sign Out"]
    
    var imageArray = ["HomeImage","favourites","Profile & membershipImage","sidePanelRedeem20","bthDayOffer","whiteNotification","HowtoUseImage","Helpimage","PowerBtn"]
    @IBOutlet weak var userImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        self.leftTableview.register(nib, forCellReuseIdentifier: "TableViewCell")
        self.leftTableview.dataSource = self
        self.leftTableview.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return nameArray.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        cell.textLabel?.text = nameArray[indexPath.row]
       // cell.textLabel?.font = CXAppConfig.sharedInstance.appMediumFont()
        //cell.imageView?.image = UIImage(named: imageArray[indexPath.row])
        
        leftTableview.allowsSelection = true
        
        //[cell setBackgroundColor:[UIColor clearColor]];
        cell .backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.white
        leftTableview.separatorStyle = .none
        return cell
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        leftTableview.rowHeight = 50
        return 50
        
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
