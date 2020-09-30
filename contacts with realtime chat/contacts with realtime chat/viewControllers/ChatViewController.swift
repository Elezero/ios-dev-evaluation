//
//  ChatViewController.swift
//  contacts with realtime chat
//
//  Created by Luis Quijada on 9/29/20.
//  Copyright © 2020 Elesteam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ChatViewController: UIViewController {

    //View items
    @IBOutlet weak var tf_message: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    var chatMessages: [ChatMessage] = []
    
    var user:User?
    
    var chat:Chat?
    var userChat:UserChat?
    
    var myuid:String = ""
    var myname:String = ""
    
    var db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        //Getting my uid
        myuid = Auth.auth().currentUser?.uid as! String
        
        //getting my name
        myname = UserDefaults.standard.string(forKey: "firstname")!
        
        
        getMessages()
        
        
    }
    
    func getChatRoot(){
        //get chat room
        db.collection("user-chats")
            .document(myuid)
            .collection("chats")
            .document(user!.email)
            .getDocument { (document, error) in
                if let document = document, document.exists {
                    let uid = document.get("uid") as! String
                    let receiver_uid = document.get("receiver_uid") as! String
                    let receiver_name = document.get("receiver_name") as! String
                    let last_message_uid = document.get("last_message_uid") as! String
                    let date_timestap = document.get("date_timestamp") as! String
                    
                    self.userChat = UserChat(uid: uid,
                                        receiver_uid: receiver_name,
                                        receiver_name: receiver_name,
                                        last_message_uid: last_message_uid,
                                        date_timestamp: date_timestap)
                    
                    self.getMessages()
                } else {
                    print("Document does not exist")
                }
            }

    }
    
    
    func getMessages(){
        if(user != nil){
            //GET Messages  -----------------
            chatMessages = []
            
            
            db.collection("chat-messages")
                .document(myuid)
                .collection("user-chat")
                .document((user?.firstName.lowercased())!)
                .collection("messages")
                .getDocuments {(snapshot, error) in
                if error == nil && snapshot != nil {
                    
                    for document in snapshot!.documents {
                        //let documentData = document.data()
                        let did = document.documentID
                        let from = document.get("from") as! String
                        let date = document.get("date") as! String
                        let time = document.get("time") as! String
                        let message = document.get("message") as! String
                        let date_timestamp = document.get("date_timestamp") as! String
                        
                        //create object
                        let chatMessage = ChatMessage(from: from,
                                                      date: date,
                                                      time: time,
                                                      message: message,
                                                      date_timestamp: date_timestamp)
                        
                        
                        
                        //Add reports to array
                        self.chatMessages.append(chatMessage)
                        
                    }
                    
                    //RELOAD TABLE
                    self.tableView.reloadData()
                    
                }
            }
        }
        
    }
    
    

    //Button actions
    //Button send message -> pressed
    @IBAction func btn_send_pressed(_ sender: Any) {
        print("@@ btn send pressed")
        
        
        if(tf_message.text != ""){
            print("@@ message long")
            
            
            //create message
            let chatMessage = ChatMessage(from: myuid, date: "", time: "", message: tf_message.text!, date_timestamp: "")
            
            
            print("@@ user chat uid empty")
                
            self.chatMessages.append(chatMessage)
            self.tableView.reloadData()
            
            //sending message
            self.sendMessage(message: self.tf_message.text!)
            
        }
    }
    
    
    func sendMessage(message:String){
        //create message
        print("@@ send message")
        
        
        db.collection("chat-messages")
        .document(myuid)
        .collection("user-chat")
        .document((user?.firstName.lowercased())!)
        .collection("messages")
            .document().setData([
            "from": myuid,
            "date": "",
            "time": "",
            "message": message,
            "date_timestamp": "",
        ]) { err in
            if err != nil {
                print("Error")
                
                //Remove loading indicator
                
                
            }else{
                print("Done adding chat message")
                
                //Cleaning textfield
                self.tf_message.text = ""
            }
        }
    }
}





// Extension for Table View
extension ChatViewController: UITableViewDataSource,
                                            UITableViewDelegate {
    
    //Get table rows count
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    //Get selected cell
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = chatMessages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ChatCell") as! ChatTableViewCell
        
        cell.setMessage(from: myname, message: message.message)
        
        return cell
    }
    
    
    //Click on table element
    func tableView(_ tableView: UITableView, didSelectRowAt
       indexPath: IndexPath) {
       //print("row selected : \(indexPath.row)")
        //self.actualContact = chatMessages[indexPath.row]
        //performSegue(withIdentifier: "gtChatSegue", sender: self)
    }
}
