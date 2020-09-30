//
//  UserChat.swift
//  contacts with realtime chat
//
//  Created by Luis Quijada on 9/30/20.
//  Copyright © 2020 Elesteam. All rights reserved.
//

import Foundation

class UserChat {
    var uid:String
    var receiver_uid:String
    var receiver_name:String
    var last_message_uid:String
    var date_timestamp:String
    
    init(uid:String, receiver_uid:String, receiver_name:String,
         last_message_uid:String, date_timestamp:String) {
        self.uid = uid
        self.receiver_uid = receiver_uid
        self.receiver_name = receiver_name
        self.last_message_uid = last_message_uid
        self.date_timestamp = date_timestamp
    }
}
