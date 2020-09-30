//
//  NewContactViewController.swift
//  contacts with realtime chat
//
//  Created by Luis Quijada on 9/29/20.
//  Copyright © 2020 Elesteam. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class NewContactViewController: UIViewController {

    
    //View items
    @IBOutlet weak var tf_first_name: UITextField!
    @IBOutlet weak var tf_last_name: UITextField!
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_contact_number: UITextField!
    
    
    var user:User?
    var ie:Bool = false
    
    
    var vSpinner : UIView?
    
    
    //instatiate firetore db
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // if is editing user contact
        if(user != nil){
            tf_email.text = user?.email
            tf_last_name.text = user?.lastName
            tf_first_name.text = user?.firstName
            tf_contact_number.text = user?.contactNumber
            
            ie = true
        }
    }
    

    //Button actions
    //Button save -> pressed
    @IBAction func btn_save_pressed(_ sender: Any) {
        if(tf_email.text != "" && tf_contact_number.text != ""
            && tf_first_name.text != "" && tf_last_name.text != ""){
            

            //Show loading indicator
            self.showSpinner(onView: self.view)
            
            // NORMAL FLOW
            let email = tf_email.text
            let contact_number = tf_contact_number.text
            let firstName = tf_first_name.text
            let lastName = tf_last_name.text
            
            
            //GETTING UID (if exists on DB)
            db.collection("users").whereField("email", isEqualTo: email)
                .getDocuments(){(snapshot, error) in
                    if let snapshot = snapshot {
                        var fuid:String = ""
                        
                        for document in snapshot.documents {
                            fuid = document.get("uid") as! String
                        }
                        
                        
                        
                        let myuid = Auth.auth().currentUser?.uid
                        
                        if(self.user?.did == nil){
                            // get next document id
                            self.user!.did = self.db.collection("contacts-list")
                            .document(myuid!).collection("contacts").document().documentID
                        }
                        
                        //ADDING TO MY CONTACT LIST
                        self.db.collection("contacts-list")
                            .document(myuid!).collection("contacts")
                            .document(self.user!.did).setData([
                            "uid": fuid,
                            "email": email,
                            "contactNumber": contact_number,
                            "firstName": firstName,
                            "lastName": lastName,
                        ]) { err in
                            if err != nil {
                                print("Error")
                                
                                //Remove loading indicator
                                self.removeSpinner()
                                
                                
                                let alert = UIAlertController(title: "Error",
                                      message: "error adding contact",
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
                                print("Done adding contact")
                                
                                //Remove loading indicator
                                self.removeSpinner()
                                
                                //DONE, GO BACK
                                _ = self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
            }
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
