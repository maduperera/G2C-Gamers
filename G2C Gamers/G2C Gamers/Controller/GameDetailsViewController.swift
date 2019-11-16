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

    var game: Game?
    var provider = MoyaProvider<G2C>()
    var favouriteBarButtonItem: UIBarButtonItem?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    enum Preference{
        case favourite
        case unfavourite
        case none
    }
    
    private var preference:Preference = .unfavourite{
        didSet{
            switch preference {
            case .favourite:
                favouriteBarButtonItem?.title = "Favourited"
            case .unfavourite:
                favouriteBarButtonItem?.title = "Favourite"
            case .none:
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
        
        guard let id = game?.id else {return}
        preference = isFavourite(id: id) ? Preference.favourite : Preference.unfavourite
        
        // hide back button till everything loads
        //self.navigationItem.setHidesBackButton(true, animated:true);
        
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
                            
                            guard let imagePath = self.game?.background_image else {return}
                            self.imgGame.kf.setImage(with: URL(string: imagePath),
                                                 options: [.transition(.fade(0.3))])
                            // show back button after everything loads
                            //self.navigationItem.setHidesBackButton(false, animated:true);
                            
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
            // delete from db
            guard let id = game?.id else {return}
            DBHandler.sharedInstance.deleteRow(idVal: id)
            DBHandler.sharedInstance.readAll()
        case .unfavourite:
            preference = .favourite
            // write to db
            guard var game = game else {return}
            game.favourite = true
            DBHandler.sharedInstance.writeRow(game: game)
            DBHandler.sharedInstance.readAll()
        case .none:
            preference = .none
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
        var cell:UITableViewCell
        switch indexPath.row{
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "GameDescriptionCell", for: indexPath) as? GameDescriptionCell ?? GameDescriptionCell()
            let desCell = cell as? GameDescriptionCell
            guard let game = game else {return desCell!}
            desCell?.configureWith(game)
            desCell?.delegate = self
            return desCell ?? GameDescriptionCell()
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "GameWebPageCell", for: indexPath) as? GameWebPageCell ?? GameWebPageCell()
            let webCell = cell as? GameWebPageCell
            guard let game = game else {return webCell!}
            webCell?.configureWith(url:game.redditUrl, title: "Visit reddit")
            return webCell ?? GameWebPageCell()
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "GameWebPageCell", for: indexPath) as? GameWebPageCell ?? GameWebPageCell()
            let webCell = cell as? GameWebPageCell
            guard let game = game else {return webCell!}
            webCell?.configureWith(url:game.webUrl, title: "Visit website")
            return webCell ?? GameWebPageCell()
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        }
       
       return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
}


extension GameDetailsViewController{
    func isFavourite(id:Int) -> Bool{
        print("favourited: \(DBHandler.sharedInstance.getPreference(gameId: id))")
        return DBHandler.sharedInstance.getPreference(gameId: id)
    }
}
