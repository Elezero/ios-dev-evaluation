//
//  Message.swift
//  contacts with realtime chat
//
//  Created by Luis Quijada on 9/29/20.
//  Copyright © 2020 Elesteam. All rights reserved.
//

import Foundation

class Message {
    var id:String
    var user_id:String
    var user_name:String
    var title:String
    var text:String
    var date:String
    var time:String
    var date_timestamp:String
    
    init(id:String, user_id:String, user_name:String, title:String,
         text:String, date:String, time:String, date_timestamp:String){
        self.id = id
        self.user_id = user_id
        self.user_name = user_name
        self.title = title
        self.text = text
        self.date = date
        self.time = time
        self.date_timestamp = date_timestamp
    }
}
