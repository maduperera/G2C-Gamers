//
//  gameCell.swift
//  G2C Gamers
//
//  Created by Madusha on 11/12/19.
//  Copyright © 2019 Madusha. All rights reserved.
//

import UIKit
import Kingfisher

class GameCell: UITableViewCell {
    
    public static let reuseIdentifier = "GameCell"
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgThumb: UIImageView!
    @IBOutlet weak var lblMetaCriticsCount: UILabel!
    @IBOutlet weak var lblGenere: UILabel!
    
    public func configureWith(_ game: Game) {
        lblTitle.text = game.name
        lblMetaCriticsCount.text = String(game.metacritic)
        
        guard let imagePath = game.background_image else {return}
        imgThumb.kf.setImage(with: URL(string: imagePath),
                             options: [.transition(.fade(0.3))])
        
        
    }
}

