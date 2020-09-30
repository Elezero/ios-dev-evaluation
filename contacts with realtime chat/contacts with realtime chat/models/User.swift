//
//  User.swift
//  contacts with realtime chat
//
//  Created by Luis Quijada on 9/29/20.
//  Copyright © 2020 Elesteam. All rights reserved.
//

import Foundation

class User {
    var uid: String
    var did: String
    var email: String
    var firstName: String
    var lastName: String
    var contactNumber: String
    
    
    init(uid:String, did:String, email:String, firstName:String, lastName:String,
         contactNumber:String){
        self.uid = uid
        self.did = did
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.contactNumber = contactNumber
    }
}
