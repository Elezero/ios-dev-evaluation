//
//  InputValidations.swift
//  contacts with realtime chat
//
//  Created by Luis Quijada on 9/30/20.
//  Copyright © 2020 Elesteam. All rights reserved.
//

import Foundation


//Check if valid email
func isValidEmail(_ email: String) -> Bool {
  let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
  let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
  return emailPred.evaluate(with: email)
}

//Check if valid password
func isValidPassword(_ password: String) -> Bool {
  let minPasswordLength = 6
  return password.count >= minPasswordLength
}
