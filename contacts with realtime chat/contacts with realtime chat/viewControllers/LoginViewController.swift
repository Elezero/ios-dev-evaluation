//
//  LoginViewController.swift
//  contacts with realtime chat
//
//  Created by Luis Quijada on 9/29/20.
//  Copyright © 2020 Elesteam. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    //View items
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_password: UITextField!
    @IBOutlet weak var btn_login: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Check if is already logged ---------------
        //NO LOGGED FLOW (STAY IN LOGIN)
        if(isLogged() == 0){
            
        }
        //NORMAL FLOW (GO TO CONTACTS)
        else{
            print("YES logged ----")
        

            // Configure firebase database
            //ref = Database.database().reference()
        }
    }
    

    
    //Buttons actions
    //Button Login -> pressed
    @IBAction func btn_login_pressed(_ sender: Any) {
        //For now in this 90mins version, this button action
        // is working without database to test the app.
        
        
        //Go to Contacs View
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let setupViewController = storyboard.instantiateViewController(
            withIdentifier:"ContactsPage") as UIViewController
        self.navigationController?.setViewControllers(
            [setupViewController], animated: true)
    }
    
    //Button forgot password -> pressed
    @IBAction func btn_forgot_password_pressed(_ sender: Any) {
    }
    
    //Button register -> pressed
    @IBAction func btn_register_pressed(_ sender: Any) {
    }
    
    
    
}
