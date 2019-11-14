//
//  File.swift
//  G2C Gamers
//
//  Created by Madusha on 11/14/19.
//  Copyright © 2019 Madusha. All rights reserved.
//

import UIKit

protocol LoadMoreDelegate {
    func moreTapped(cell: GameDescriptionCell)
}

class GameDescriptionCell: UITableViewCell {
    
    @IBOutlet weak var lblLoadMore: UIButton!
    @IBOutlet weak var gameDesc: UILabel!
    var delegate: LoadMoreDelegate?
   
    var isExpanded = false
    
    @IBAction func loadMore(_ sender: Any) {
        if sender is UIButton {
            isExpanded = !isExpanded
            
            gameDesc.numberOfLines = isExpanded ? 0 : 4
            lblLoadMore.setTitle(isExpanded ? "Read less..." : "Read more...", for: .normal)
            
            delegate?.moreTapped(cell: self)
        }
    }
    
    public static let reuseIdentifier = "GameDescriptionCell"
    
    public func configureWith(_ game: Game) {
        
        detailTextLabel?.numberOfLines = 4
        gameDesc.text = game.description
        
    }
    
    
    
}
