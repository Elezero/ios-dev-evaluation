//
//  ChatMessage.swift
//  contacts with realtime chat
//
//  Created by Luis Quijada on 9/29/20.
//  Copyright © 2020 Elesteam. All rights reserved.
//

import Foundation

class ChatMessage {
    var from:String
    var date:String
    var time:String
    var message:String
    var date_timestamp:String //will change to timestamp
    
    init(from:String, date:String, time:String, message:String, date_timestamp:String){
        self.from = from
        self.date = date
        self.time = time
        self.message = message
        self.date_timestamp = date_timestamp
    }
}
