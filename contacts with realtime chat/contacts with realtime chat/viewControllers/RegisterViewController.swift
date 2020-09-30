//
//  RegisterViewController.swift
//  contacts with realtime chat
//
//  Created by Luis Quijada on 9/29/20.
//  Copyright © 2020 Elesteam. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    //View items
    @IBOutlet weak var tf_first_name: UITextField!
    @IBOutlet weak var tf_last_name: UITextField!
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_contact_number: UITextField!
    @IBOutlet weak var tf_password: UITextField!
    @IBOutlet weak var tf_password_reenter: UITextField!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    //Button actions
    //Button register -> pressed
    @IBAction func btn_register_pressed(_ sender: Any) {
    }
    
}
