//
//  LoginViewController.swift
//  contacts with realtime chat
//
//  Created by Luis Quijada on 9/29/20.
//  Copyright © 2020 Elesteam. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {

    //View items
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_password: UITextField!
    @IBOutlet weak var btn_login: UIButton!
    
    
    var vSpinner : UIView?
    
    //instatiate firetore db
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Check if is already logged ---------------
        //NO LOGGED FLOW (STAY IN LOGIN)
        if(isLogged() == 0){
            
        }
        //NORMAL FLOW (GO TO CONTACTS)
        else{
            print("YES logged ----")
        

            //Go to Contacs View
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let setupViewController = storyboard.instantiateViewController(
                withIdentifier:"ContactsPage") as UIViewController
            self.navigationController?.setViewControllers(
                [setupViewController], animated: true)
        }
        
    }
    

    
    //Buttons actions
    //Button Login -> pressed
    @IBAction func btn_login_pressed(_ sender: Any) {
        
        //Show loading indicator
        self.showSpinner(onView: self.view)
        
        
        if(tf_email.text == "" || tf_password.text == ""){

            //Remove loading indicator
            self.removeSpinner()
            
            
            //ERROR FLOW: Show error
            showErrorAlert(text: "Please enter all fields")
        }
        // NORMAL FLOW
        else{
            let email: String = tf_email.text!
            let password: String = tf_password.text!
            
            if(isValidEmail(email) && isValidPassword(password)){
                
                Auth.auth().signIn(withEmail: email, password: password) {
                    (authResult, error) in
                    
                    if let error = error as NSError? {
                    switch AuthErrorCode(rawValue: error.code) {
                    case .operationNotAllowed:
                        self.showErrorAlert(text: "Operation not allowed")
                        break
                      // Error: Indicates that email and password no enabled
                    case .userDisabled:
                        self.showErrorAlert(text: "Account disabled")
                        break
                      // Error: The user account has been disabled
                    case .wrongPassword:
                        self.showErrorAlert(text: "Wrong password")
                        break
                      // Error: The password is invalid or the user d
                    case .invalidEmail:
                        self.showErrorAlert(text: "Invalid email")
                      // Error: Indicates the email address is malformed.
                    default:
                        print("Error: \(error.localizedDescription)")
                    }

                    //Remove loading indicator
                    self.removeSpinner()
                    
                  } else {
                        print("User signs in successfully")
                        let userInfo = Auth.auth().currentUser
                        let email = userInfo?.email
                        let uid = userInfo?.uid
                        var firstName = ""
                        var lastName = ""
                            var _:[String: Any] = [:]
                        
                        //SAVING LOCAL DATA
                        UserDefaults.standard.set(email, forKey: "email")
                        UserDefaults.standard.set(uid, forKey: "uid")
                    
                    
                        //GETTING NAMES
                        self.db.collection("users").document(uid!).getDocument(){
                            (document, error) in
                            
                            firstName = document?.get("firstName") as! String
                            lastName = document?.get("lastName") as! String
                                
                                
                                
                            print("Name: \(firstName)")
                            
                            //SAVING LOCAL DATA
                            if(firstName != "" && lastName != ""){
                                UserDefaults.standard.set(firstName, forKey: "firstname")
                                UserDefaults.standard.set(lastName, forKey: "lastname")
                                UserDefaults.standard.set(1, forKey: "logged")
                                

                                //Remove loading indicator
                                self.removeSpinner()
                                
                                
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
            else{
                
                //Remove loading indicator
                self.removeSpinner()
                
                //ERROR FLOW: Show error
                showErrorAlert(text: "Please enter a valid email and password")
                
            }
        }
    }
    
    
    
    
    
    
    // Error alert dialog
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
    
    
    
    //Show loading spinner
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
    
    //Remove loading spinner
    func removeSpinner() {
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
}
