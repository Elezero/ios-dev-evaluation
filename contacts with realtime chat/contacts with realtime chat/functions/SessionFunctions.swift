//
//  SessionFunctions.swift
//  contacts with realtime chat
//
//  Created by Luis Quijada on 9/29/20.
//  Copyright © 2020 Elesteam. All rights reserved.
//

import Foundation

func isLogged() -> Int{
    var isl: Int = 0
    
    if(UserDefaults.standard.integer(forKey: "logged") != nil){
        isl = UserDefaults.standard.integer(forKey: "logged")
    }

    return isl
}
