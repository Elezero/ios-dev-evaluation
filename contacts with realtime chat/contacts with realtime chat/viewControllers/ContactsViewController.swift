//
//  ContactsViewController.swift
//  contacts with realtime chat
//
//  Created by Luis Quijada on 9/29/20.
//  Copyright © 2020 Elesteam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ContactsViewController: UIViewController, UISearchBarDelegate {
    
    //View items
    @IBOutlet weak var btn_new_contact: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //Lists
    var filteredContacts: [User] = []
    var contacts: [User] = []
    var actualContact: User?
    
    
    
    var db = Firestore.firestore()
    var myuid:String? = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        //Hidding back button because if is in this view
        // suppose is already logged
        navigationItem.hidesBackButton = false
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        searchBar.delegate = self
        
        //instatiate firetore db
        //db = Firestore.firestore()
        
        myuid = Auth.auth().currentUser?.uid

        //getContacts()
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getContacts()
    }
    
    
    func getContacts(){
        filteredContacts = []
        
        //GET Contacts -----------------
        db.collection("contacts-list")
            .document(myuid!)
            .collection("contacts")
            .getDocuments {(snapshot, error) in
            if error == nil && snapshot != nil {
                
                for document in snapshot!.documents {
                    //let documentData = document.data()
                    let did = document.documentID
                    let uid = document.get("uid") as! String
                    let firstName = document.get("firstName") as! String
                    let lastName = document.get("lastName") as! String
                    let email = document.get("email") as! String
                    let contactNumber = document.get("contactNumber") as! String
                    
                    //create object
                    let contact: User = User(uid: uid,
                                             did: did,
                                          email: email,
                                          firstName: firstName,
                                          lastName: lastName,
                                          contactNumber: contactNumber)
                    
                    //Add reports to array
                    self.filteredContacts.append(contact)
                    
                    self.contacts = self.filteredContacts
                }
                
                //RELOAD TABLE
                self.tableView.reloadData()
                
            }
        }
    }
}


// Extension for Table View
extension ContactsViewController: UITableViewDataSource,
                                            UITableViewDelegate {
    
    //Get table rows count
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return filteredContacts.count
    }
    
    //Get selected cell
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contact = filteredContacts[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ContactCell") as! ContactTableViewCell
        
        cell.setContact(contact: contact)
        
        return cell
    }
    
    
    //Click on table element
    func tableView(_ tableView: UITableView, didSelectRowAt
       indexPath: IndexPath) {
       //print("row selected : \(indexPath.row)")
        self.actualContact = filteredContacts[indexPath.row]
        performSegue(withIdentifier: "gtChatSegue", sender: self)
    }
    
    //slide options
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            //requesting confirm
            // Declare Alert message
            let dialogMessage = UIAlertController(
                title: "Confirm",
                message: "Are you sure you want to delete this?",
                preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default,
                                   handler: { (action) -> Void in
                 print("Ok button tapped")
                 //DELETING FROM DB
                //detele from db
                self.db.collection("contacts-list")
                    .document(self.myuid!)
                    .collection("contacts")
                    .document(self.contacts[indexPath.item].did)
                    .delete(){ err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed!")
                            self.getContacts()
                        }
                    }
            })
            
            // Create Cancel button with action handlder
            let cancel = UIAlertAction(title: "Cancel",
                                       style: .cancel) { (action) -> Void in
                print("Cancel button tapped")
            }
            
            //Add OK and Cancel button to dialog message
            dialogMessage.addAction(ok)
            dialogMessage.addAction(cancel)
            
            // Present dialog message to user
            self.present(dialogMessage, animated: true, completion: nil)
            
          
        
        }

        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            // share item at indexPath
            
            self.actualContact = self.contacts[indexPath.item]
            
            
            self.performSegue(withIdentifier: "gtNewContactSegue", sender: self)
            
            print("I want to edit: \(self.contacts[indexPath.row])")
        }

        edit.backgroundColor = UIColor.lightGray

        return [delete, edit]

    }
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searching...: \(searchText)")
        filteredContacts = searchText.isEmpty ? contacts : contacts.filter({(contact: User) -> Bool in
            
            if(contact.firstName.lowercased().contains(searchText.lowercased())
               || contact.lastName.lowercased().contains(searchText.lowercased())){
                return true
            }else{
                return false
            }
                
        })

        tableView.reloadData()
    }
    
    
    /*
       This prepare is use for send data to the another view.
       In this case send the data (user) to the view
           NewContactViewController.
       It works instantiating te view controller and setting
           the attribute that we want to pass.
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "gtNewContactSegue":
            let vc = segue.destination as! NewContactViewController
            vc.user = self.actualContact
            
        case "gtChatSegue":
            let vc = segue.destination as! ChatViewController
            vc.user = self.actualContact
        default:
            break
        }
    }
}
