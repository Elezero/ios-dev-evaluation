//
//  ContactsViewController.swift
//  contacts with realtime chat
//
//  Created by Luis Quijada on 9/29/20.
//  Copyright © 2020 Elesteam. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {
    
    //View items
    @IBOutlet weak var btn_new_contact: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //Hidding back button because if is in this view
        // suppose is already logged
        navigationItem.hidesBackButton = false
    }
    

    //Buttons actions
    @IBAction func btn_new_contact_pressed(_ sender: Any) {
    }
    
    

}
