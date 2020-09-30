//
//  ForgotPasswordViewController.swift
//  contacts with realtime chat
//
//  Created by Luis Quijada on 9/29/20.
//  Copyright © 2020 Elesteam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {
    
    //View items
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var btn_recover: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    //Button actions
    @IBAction func btn_recover_pressed(_ sender: Any) {
        if(tf_email.text!.count > 3){
            Auth.auth().sendPasswordReset(withEmail: tf_email.text!) { error in
                
                self.showErrorAlert(text: "Reset password email sent")
                self.btn_recover.isEnabled = false
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
    
    
}
