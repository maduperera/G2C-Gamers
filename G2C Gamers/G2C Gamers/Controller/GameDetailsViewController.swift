//
//  GameDetailsViewController.swift
//  G2C Gamers
//
//  Created by Madusha on 11/12/19.
//  Copyright © 2019 Madusha. All rights reserved.
//

import UIKit

class GameDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func instantiate() -> GameDetailsViewController {
        guard let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "GameDetailsViewController") as? GameDetailsViewController else { fatalError("Unexpectedly failed getting ComicViewController from Storyboard") }
        
        return vc
    }

}

extension GameDetailsViewController {
    //    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    //        return true
    //    }
    //
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if (editingStyle == .none) {
    //            // handle delete (by removing the data from your array and updating the tableview)
    //        }
    //    }
}
