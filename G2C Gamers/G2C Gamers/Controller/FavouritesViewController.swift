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
        items = DBHandler.sharedInstance.readAll()
        print(items)
       
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

