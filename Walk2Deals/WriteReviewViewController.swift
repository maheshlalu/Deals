//
//  WriteReviewViewController.swift
//  Walk2Deals
//
//  Created by Rama kuppa on 05/10/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

protocol ReviewSubMitDelegate {
    func didSubmitReview()
}


class WriteReviewViewController: UIViewController {

    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var rattingView: FloatRatingView!
    @IBOutlet weak var commentTextView: UITextView!
    var delegate : ReviewSubMitDelegate!
    var dealID : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.commentTextView.layer.borderWidth = 2.0
        self.commentTextView.layer.borderColor = UIColor.gray.cgColor
        self.commentTextView.layer.masksToBounds = true
        
        self.userImgView.layer.cornerRadius = 45
        self.userImgView.layer.borderWidth = 2
        self.userImgView.layer.masksToBounds = true
        
        let profile = CXDataSaveManager.sharedInstance.getTheUserProfileFromDB()

        if let img =  profile.image as? String{
            let url = URL(string: CXDataSaveManager.sharedInstance.getTheUserProfileFromDB().image)
            self.userImgView.setImageWith(url, usingActivityIndicatorStyle: .white)
            
            self.userNameLbl.text = profile.firstName + "  " + profile.lastName
            
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func submitReviewAction(_ sender: UIButton) {
        //Dealid,user ID,reviewstar,reviewcomments
        
            CXDataService.sharedInstance.showLoader(view: self.view, message: "Submitting...")
        
                let parameters = ["Dealid":self.dealID,"user ID":CXAppConfig.sharedInstance.getUserID(),"reviewstar":"\(self.rattingView.rating)","reviewcomments":self.commentTextView.text] as [String : Any]
                
                CXDataService.sharedInstance.postTheDataToServer(urlString: CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.saveReviewUrl(), parameters: parameters as! [String : String]) { (responceDic) in
                    CXLog.print("responce dict \(responceDic)")
                    CXDataService.sharedInstance.hideLoader()
                    let error = responceDic.value(forKey: "Errors") as? NSArray
                    let errorDict = error?.lastObject as? NSDictionary
                    let errorcode = errorDict?.value(forKey: "ErrorCode") as? String
                    
                    if errorcode == "0"{
                        if (self.delegate != nil){
                            self.delegate.didSubmitReview()
                            self.view.makeToast(message: "Review Posted Successfully!!!")
                            self.navigationController?.popViewController(animated: true)
                        }
                    }else{
                        
                        CXDataService.sharedInstance.showAlert(message: "Something went Wrong!!!", viewController: self)
                    }
                    
                }
                
            
        
    }
}
