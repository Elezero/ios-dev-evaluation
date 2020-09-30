//
//  RegisterViewController.swift
//  contacts with realtime chat
//
//  Created by Luis Quijada on 9/29/20.
//  Copyright © 2020 Elesteam. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class RegisterViewController: UIViewController {

    //View items
    @IBOutlet weak var tf_first_name: UITextField!
    @IBOutlet weak var tf_last_name: UITextField!
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_contact_number: UITextField!
    @IBOutlet weak var tf_password: UITextField!
    @IBOutlet weak var tf_password_reenter: UITextField!
    
    
    
    var vSpinner : UIView?
    
    //instatiate firetore db
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    //Button actions
    //Button register -> pressed
    @IBAction func btn_register_pressed(_ sender: Any) {
        //Show loading indicator
        self.showSpinner(onView: self.view)
        
        
        if(isValidEmail(tf_email.text!) && isValidPassword(tf_password.text!)
            && tf_first_name.text != "" && tf_last_name.text != ""){
            
            // NORMAL FLOW
            let email = tf_email.text
            let password = tf_password.text
            _ = tf_first_name.text
            _ = tf_last_name.text
            
            //Signing up
            Auth.auth().createUser(withEmail: email!, password: password!) {
                authResult, error in
                
                if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                case .operationNotAllowed:
                  // Error: The given sign-in provider is disabled
                    self.showErrorAlert(text: "Not available")
                    break
                case .emailAlreadyInUse:
                  // Error: The email address is already in use by another account.
                    self.showErrorAlert(text: "Email already in use")
                    break
                case .invalidEmail:
                  // Error: The email address is badly formatted.
                    self.showErrorAlert(text: "Invalid email")
                    break
                case .weakPassword:
                  // Error: The password must be 6 characters long or more.
                    self.showErrorAlert(text: "Password must be 6 characters long or more")
                    break
                    
                default:
                    print("Error: \(error.localizedDescription)")
                }
                
                //Remove loading indicator
                self.removeSpinner()
                    
              } else {
                print("User signs up successfully")
                let newUserInfo = Auth.auth().currentUser
                let email = newUserInfo?.email
                let uid = newUserInfo!.uid
                
                //Saving name and surname to database
                    self.db.collection("users").document(uid).setData([
                        "uid": uid,
                        "email": email,
                        "firstName": self.tf_first_name.text,
                        "lastName": self.tf_last_name.text,
                    ]) { err in
                        if err != nil {
                            print("Error")
                            let alert = UIAlertController(title: "Error",
                                  message: "error adding user",
                                  preferredStyle: UIAlertController.Style.alert)
                            let alertAction = UIAlertAction(title: "OK",
                                            style: UIAlertAction.Style.default)
                                    {
                                        (UIAlertAction) -> Void in
                                    }
                                    alert.addAction(alertAction)
                                    self.present(alert, animated: true)
                                    {
                                        () -> Void in
                                    }
                        }else{
                            print("Done creating user")
                            
                            UserDefaults.standard.set(self.tf_first_name.text, forKey: "firstname")
                            UserDefaults.standard.set(self.tf_last_name.text, forKey: "lastname")
                            UserDefaults.standard.set(1, forKey: "logged")
                            

                            //Remove loading indicator
                            //self.removeSpinner()
                            
                            
                            //GO TO MAIN PAGE
                            //go to setup (and select country) view
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let setupViewController = storyboard.instantiateViewController(
                                withIdentifier:"ContactsPage") as UIViewController
                            self.navigationController?.setViewControllers(
                                [setupViewController], animated: true)
                        }
                    }
                }
              }
            }
    }
    
    func showErrorAlert(text:String){
        let alert = UIAlertController(title: "Error",
              message: text,
              preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "OK",
                        style: UIAlertAction.Style.default)
                {
                    (UIAlertAction) -> Void in
                }
                alert.addAction(alertAction)
                self.present(alert, animated: true)
                {
                    () -> Void in
                }
    }
    
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(
            red: 0.5,
            green: 0.5,
            blue: 0.5,
            alpha: 0.5)
        
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
}
