//
//  UserProfileViewController.swift
//  Sample
//
//  Created by Manishi on 10/14/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userProfileTableView: UITableView!
    
    var textFieldArray = ["Mobile No","First Name","Last Name","Email","Aadhaar"]
    
    
    var mobileNoTextField = UITextField()
    var firstNameTextField = UITextField()
    var lastNameTextField = UITextField()
    var emailTextField = UITextField()
    var aadhaarTextField = UITextField()
    var profileImageData : NSData!
    var editImageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "UserProfileTableViewCell", bundle: nil)
        
        self.userProfileTableView.register(nib, forCellReuseIdentifier: "UserProfileTableViewCell")
        
        self.userImageView.layer.cornerRadius = 50
        self.userImageView.layer.borderWidth = 2
        self.userImageView.layer.masksToBounds = true

        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        
        return textFieldArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileTableViewCell", for: indexPath) as? UserProfileTableViewCell
        
        if indexPath.row == 0{
            
            cell?.userProfileTextField.placeholder = "Mobile No"
            self.mobileNoTextField.text = cell?.userProfileTextField.text
            
        }else if indexPath.row == 1{
            
            cell?.userProfileTextField.placeholder = "First Name"
            self.firstNameTextField.text = cell?.userProfileTextField.text
        }else if indexPath.row == 2{
            
            
             cell?.userProfileTextField.placeholder = "Last Name"
            self.lastNameTextField.text = cell?.userProfileTextField.text
        }else if indexPath.row == 3{
            
            
            cell?.userProfileTextField.placeholder = "Email"
            self.emailTextField.text = cell?.userProfileTextField.text
        }else if indexPath.row == 4{
            
            cell?.userProfileTextField.placeholder = "Aadhaar"
            self.aadhaarTextField.text = cell?.userProfileTextField.text
            
        }
        
      
        cell?.selectionStyle = .none
        return cell!
    }
    
    func validationTextField(){
        
        
        if self.mobileNoTextField.text?.characters.count == 0 || self.firstNameTextField.text?.characters.count == 0 || self.lastNameTextField.text?.characters.count == 0 || self.emailTextField.text?.characters.count == 0 || self.aadhaarTextField.text?.characters.count == 0{
            showAlert()
            
        }
    }
    
    func showAlert(){
        
        let alertController = UIAlertController(title: "Walk2Deals", message: "Please Enter All Fields", preferredStyle: .alert)
        
        let alrtAction = UIAlertAction(title: "Ok", style: .cancel) { (alrtAction) in
            
            
        }
        
        alertController.addAction(alrtAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        
        validationTextField()
        
        
    }
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        
    }
    
    /*Image Picker Action  */
    func imagePickerAction(){
        //Create the AlertController and add Its action like button in Actionsheet
        let choosePhotosActionSheet: UIAlertController = UIAlertController(title: "Select An Option", message: nil , preferredStyle: .actionSheet)
        
        let chooseFromPhotos: UIAlertAction = UIAlertAction(title: "Choose From Photos", style: .default)
        { action -> Void in
            //print("choose from photos")
            let image = UIImagePickerController()
            image.delegate = self
            image.sourceType = .photoLibrary
            image.allowsEditing = false
            self.present(image, animated: true, completion: nil)
        }
        choosePhotosActionSheet.addAction(chooseFromPhotos)
        
        let capturePicture: UIAlertAction = UIAlertAction(title: "Capture Image", style: .default)
        { action -> Void in
            //print("camera shot")
            let picker = UIImagePickerController()
            picker.allowsEditing = false
            picker.delegate = self
            picker.sourceType = .camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            self.present(picker, animated: true, completion: nil)
        }
        choosePhotosActionSheet.addAction(capturePicture)
        
        let noImage: UIAlertAction = UIAlertAction(title: "Remove Image", style: .default)
        { action -> Void in
            //self.editImageView.image = UIImage(named: "placeholder")
            UserDefaults.standard.set(nil, forKey: "IMG_DATA")
        }
        choosePhotosActionSheet.addAction(noImage)
        
        let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        { action -> Void in
            print("Delete")
            //self.saveButton.isHidden = true
        }
        choosePhotosActionSheet.addAction(cancel)
        
        self.present(choosePhotosActionSheet, animated: true, completion: nil)
    }
    
    /* image Picker Controller*/
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var image = UIImage()
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image = pickedImage as UIImage
            
            self.profileImageData = NSData(data: UIImagePNGRepresentation(image)!)
            UserDefaults.standard.set(profileImageData, forKey: "IMG_DATA")
            self.editImageView.image = image
            //editImage = true
            //self.imgUploadBtn.isSelected = true
            //self.profileImageData = NSData(data: UIImagePNGRepresentation(image)!)
            //UserDefaults.standard.set(profileImageData, forKey: "IMG_DATA")
            //self.editImageView.image = image
            //editImage = true
            //self.imgUploadBtn.isSelected = true
        }
        self.dismiss(animated: true, completion: nil)
      
        
    }
    
    @IBAction func uploadImageBtnAction(_ sender: UIButton) {
        
   
        
            self.imagePickerAction()
       
    }
    
    
    
}
