//
//  ChatTableViewCell.swift
//  contacts with realtime chat
//
//  Created by Luis Quijada on 9/30/20.
//  Copyright © 2020 Elesteam. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    //View items
    @IBOutlet weak var tv_message: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setMessage(from:String, message: String){
        tv_message.text = from + ": " + message
    }

}
