//
//  FavouritesViewController.swift
//  G2C Gamers
//
//  Created by Madusha on 11/16/19.
//  Copyright © 2019 Madusha. All rights reserved.
//

import UIKit

class FavouritesViewController: UIViewController {

    var items : [Game]?
    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // read all games stored
        //items = DBHandler.sharedInstance.readAll() //.filter({(game:Game) in game.favourite == true })
//        print("favouriteItems :\(items)")
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // read all games stored
        items = DBHandler.sharedInstance.readAll()
        print("favouriteItems :\(items)")
        tblView.reloadData()
    }

}



extension FavouritesViewController :  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = items else {return 0}
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = items?[indexPath.row].name
        return cell
        
    }
    
}


extension FavouritesViewController {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // delete from db
            let game = items?[indexPath.row]
            guard let id = game?.id else {return}
            DBHandler.sharedInstance.deleteRow(idVal: id)
            items = DBHandler.sharedInstance.readAll()
            tblView.reloadData()
        }
    }
}

