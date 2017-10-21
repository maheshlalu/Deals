//
//  SettingsViewController.swift
//  Walk2Deals
//
//  Created by Rama kuppa on 20/10/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var settingTableView: UITableView!
    var nameArray = ["Genaral","Notifications","About WALK2DEALS","Rate on AppStore","Recommend","Write a Review"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingTableView.contentInset = UIEdgeInsetsMake(5, 10, 10, 10)
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        self.title = "Settings"
        self.settingTableView.register(nib, forCellReuseIdentifier: "TableViewCell")
        self.setUpBackButton()
        // Do any additional setup after loading the view.
    }

    func setUpBackButton(){
        let menuItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(SettingsViewController.backAction(sender:)))
        self.navigationItem.leftBarButtonItem = menuItem
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backAction(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return nameArray.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        cell.textLabel?.text = nameArray[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemName : String =  nameArray[indexPath.row]

        if itemName == "Genaral"{
        }
    }
}
