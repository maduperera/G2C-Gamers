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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // read all games stored
        items = DBHandler.sharedInstance.readAll()
        tblView.reloadData()
        guard let count = items?.count else {return}
        self.title = "Favourites (\(String(count)))"
    }
    
}

extension FavouritesViewController :  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteCell.reuseIdentifier, for: indexPath) as? FavouriteCell ?? FavouriteCell()
        
        guard let items = items else {return cell}
        cell.configureWith(items[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = items else {return 0}
        return items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gameDetailsVC = GameDetailsViewController.instantiate()
        guard let items = items else { return }
        navigationItem.searchController?.isActive = false
        gameDetailsVC.inititialize(game: items[indexPath.item])
        navigationController?.pushViewController(gameDetailsVC, animated: true)
        
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
            guard let count = items?.count else {return}
            self.title = "Favourites (\(String(count)))"
        }
    }
}

