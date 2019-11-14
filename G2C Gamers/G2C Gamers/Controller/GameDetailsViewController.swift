//
//  GameDetailsViewController.swift
//  G2C Gamers
//
//  Created by Madusha on 11/12/19.
//  Copyright © 2019 Madusha. All rights reserved.
//

import UIKit
import Moya

class GameDetailsViewController: UIViewController {

    var favouriteBarButtonItem: UIBarButtonItem?
    var game: Game?
    var provider = MoyaProvider<G2C>()
    let items = [1,2,3]
    
    enum Preference{
        case favourite
        case unfavourite
    }
    
    private var preference:Preference = .unfavourite{
        didSet{
            switch preference {
            case .favourite:
                favouriteBarButtonItem?.title = "Favourited"
            case .unfavourite:
                favouriteBarButtonItem?.title = "Favourite"
            }
        }
    }
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgGame: UIImageView!
    @IBOutlet weak var tblDetails: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // by default not being favourite
        preference = .unfavourite
        favouriteBarButtonItem = UIBarButtonItem(title: "Favourite", style: .done, target: self, action: #selector(makeThisFavourite))
        self.navigationItem.rightBarButtonItem  = favouriteBarButtonItem
        lblTitle.text = game?.name
        fetchGameDetails()
        // remove unwanted cells in the table
        tblDetails.tableFooterView = UIView()
        
        tblDetails.estimatedRowHeight = 100
        tblDetails.rowHeight = UITableView.automaticDimension
    }
    
    func fetchGameDetails(){
        // fetch game data
        guard let id = game?.id else {return}
        provider.request(.gameDetails(id:id)) { result in
            switch result {
                case .success(let response):
                    do {
                        let json = try response.mapJSON()
                        if let json = json as? [String: Any]{
            
                            print("desc : \(json["description_raw"] as? String ?? "")")
                            self.game?.description = json["description_raw"] as? String ?? ""
                            self.game?.webUrl = json["website"] as? String ?? ""
                            self.game?.redditUrl = json["reddit_url"] as? String ?? ""
                            self.tblDetails.reloadData()
                        }
                
                    } catch {
                        print("json parse error")
                    }
                case .failure:
                    print("Network error")
            }
        }
    }
    
    func inititialize(game:Game){
        self.game = game
    }
    

    
    static func instantiate() -> GameDetailsViewController {
        guard let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "GameDetailsViewController") as? GameDetailsViewController else { fatalError("Unexpectedly failed getting GameDetailsViewController from Storyboard") }
        
        return vc
    }

    @objc func makeThisFavourite(){
        // toggle preference at each click
        switch preference {
        case .favourite:
            preference = .unfavourite
        case .unfavourite:
            preference = .favourite
        }
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

extension GameDetailsViewController: LoadMoreDelegate{
    func moreTapped(cell: GameDescriptionCell) {
        tblDetails.beginUpdates()
        tblDetails.endUpdates()
    }
}


extension GameDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameDescriptionCell", for: indexPath) as? GameDescriptionCell ?? GameDescriptionCell()
        guard let game = game else {return cell}
        cell.configureWith(game)
        cell.delegate = self
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        
       return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
