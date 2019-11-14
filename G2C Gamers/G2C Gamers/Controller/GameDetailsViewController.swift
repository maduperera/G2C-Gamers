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
            
                            let description:String? = json["description_raw"] as? String ?? ""
                            let webAddress:String? = json["website"] as? String ?? ""
                            let redditAddress:String? = json["reddit_url"] as? String ?? ""
                            
                            print("NEXT : \(json)")
                            print("NEXT : \(description ?? "")")
                            print("NEXT : \(webAddress ?? "")")
                            print("NEXT : \(redditAddress ?? "")")
                        
                           
                        }
                
                    } catch {
                        print("error")
                    }
                case .failure:
                    print("error")
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


extension GameDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cellGameDescription", for: indexPath) as? GameCell ?? GameCell()
//
//        //cell.configureWith(items[indexPath.item])
//        return cell
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = "Description" + String(items[indexPath.row])
        cell.detailTextLabel?.text = "Rockstar Games went bigger, since their previous installment of the series. You get the complicated and realistic world-building from Liberty City of GTA4 in the setting of lively and diverse Los Santos, from an old fan favorite GTA San Andreas. 561 different vehicles (including every transport you can operate) and the amount is rising with every update. \r\nSimultaneous storytelling from three unique perspectives: \r\nFollow Michael, ex-criminal living his life of leisure away from the past, Franklin, a kid that seeks the better future, and Trevor, the exact past Michael is trying to run away from. \r\nGTA Online will provide a lot of additional challenge even for the experienced players, coming fresh from the story mode. Now you will have other players around that can help you just as likely as ruin your mission. Every GTA mechanic up to date can be experienced by players through the unique customizable character, and community content paired with the leveling system tends to keep everyone busy and engaged."
        
        cell.detailTextLabel?.numberOfLines = 4
        
       return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
