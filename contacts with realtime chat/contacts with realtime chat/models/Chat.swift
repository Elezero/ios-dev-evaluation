//
//  Chat.swift
//  contacts with realtime chat
//
//  Created by Luis Quijada on 9/29/20.
//  Copyright © 2020 Elesteam. All rights reserved.
//

import Foundation

class Chat {
    var uid: String
    var last_message_text: String
    var last_message_time: String
    var last_message_date: String
    var date_timestamp:String //will change to Firestore-Timestamp
    
    init(uid:String,last_message_text:String, last_message_time:String,
         last_message_date:String,date_timestamp:String) {
        
        self.uid = uid
        self.last_message_date = last_message_date
        self.last_message_text = last_message_text
        self.last_message_time = last_message_time
        self.date_timestamp = date_timestamp
    }
}
