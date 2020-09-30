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
    var text:String
    var date:String
    var time:String
    
    init(id:String, user_id:String, user_name:String, text:String, date:String,
         time:String){
        self.id = id
        self.user_id = user_id
        self.user_name = user_name
        self.text = text
        self.date = date
        self.time = time
    }
}
