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
        if let name = game.name{
            lblTitle.text = name
        }
        if let metacritic = game.metacritic{
            lblMetaCriticsCount.text = String(metacritic)
        }
        guard let imagePath = game.background_image else {return}
        imgThumb.kf.setImage(with: URL(string: imagePath),
                             options: [.transition(.fade(0.3))])
        
        guard let genres = game.genres else {return}
        lblGenere.text = aggregateGenres(genres: genres)
        
    }
    
    // aggregate the genres to one line
    func aggregateGenres(genres: [Game.Genre]) -> String{
        let names = genres.map({ $0.name ?? "" })
        return names.joined(separator: ", ")
    }
    
}

