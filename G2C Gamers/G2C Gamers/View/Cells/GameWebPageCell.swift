//
//  GameWebPageCell.swift
//  G2C Gamers
//
//  Created by Madusha on 11/15/19.
//  Copyright © 2019 Madusha. All rights reserved.
//

import UIKit
import Kingfisher

class GameWebPageCell: UITableViewCell {
    
    public static let reuseIdentifier = "GameWebPageCell"
    var url:String?
    @IBOutlet weak var lblWebPage: UILabel!
    public func configureWith(url webpage:String?, title name:String) {
        url = webpage
        lblWebPage.text = name
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(btnWebpage))
        isUserInteractionEnabled = true
        addGestureRecognizer(tap)
        
    }
  
    @IBAction func btnWebpage(sender: UITapGestureRecognizer) {
        guard let url = url else {return}
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
    
}
