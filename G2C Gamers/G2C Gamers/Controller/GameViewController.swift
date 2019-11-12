//
//  ViewController.swift
//  G2C Gamers
//
//  Created by Madusha on 11/10/19.
//  Copyright © 2019 Madusha. All rights reserved.
//

import UIKit
import Moya

class GameViewController: UIViewController {

    let provider = MoyaProvider<G2C>()
    var nextPagePath : String?
    var isFetching = false
    
    // MARK: - View State
    private var state: State = .loading {
        didSet {
            switch state {
            case .ready:
                print(".ready")
                tblGames.isHidden = false
                tblGames.reloadData()
            case .loading:
                print(".loading")
                tblGames.isHidden = true
            case .error:
                print(".error")
                tblGames.isHidden = true
            }
        }
    }
    
    
    @IBOutlet weak var tblGames: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add search bar to the navigation bar
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.searchBar.placeholder = "Search for the games"
        
        state = .loading
        
        // fetch game data
        provider.request(.games) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    let json = try response.mapJSON()
                    if let json = json as? [String: Any], let next = json["next"] as? String {
                        print("NEXT : \(next)")
                        self.nextPagePath = next
                    }
                    
                    self.state = .ready(try response.map(GameResponse<Game>.self).results)
                
                } catch {
                    self.state = .error
                }
            case .failure:
                self.state = .error
            }
        }
    }
    
}


extension GameViewController {
    enum State {
        case loading
        case ready([Game])
        case error
    }
}


// MARK: - UITableView Delegate & Data Source
extension GameViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: GameCell.reuseIdentifier, for: indexPath) as? GameCell ?? GameCell()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: GameCell.reuseIdentifier) as! GameCell
        
        guard case .ready(let items) = state else { return cell }
        
        cell.configureWith(items[indexPath.item])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard case .ready(let items) = state else { return 0 }
        return items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case .ready(let items) = state, let nextPath = nextPagePath else { return }
        let last = items.count - 1

        if indexPath.row == last{
            print("indexPath.row == last")
            print(isFetching)
            if !isFetching{
                fetchNextPage(nextPath: nextPath)
            }
        }
    }
    
//    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        guard case .ready(let items) = state, let nextPath = nextPagePath else { return }
//        let last = items.count - 1
//
//        if indexPath.row == last{
//            fetchNextPage(nextPath: nextPath)
//        }
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//
//        if offsetY > contentHeight - scrollView.frame.height{
//            if !isFetching{
//                fetchNextPage(nextPath: "")
//            }
//        }
    }
    
    
    func fetchNextPage(nextPath next:String){
        isFetching = true
        print("fetch")
        guard let nextPath = next.components(separatedBy: "io/api").last else {return}
//        print("splitted next : \(next.components(separatedBy: "io/api").last!)")
        
        // fetch game data from next page
        provider.request(.nextGames(nextPath: nextPath)) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                do {
                    let json = try response.mapJSON()
                    if let json = json as? [String: Any], let next = json["next"] as? String {
                        print("NEXT : \(next)")
                        self.nextPagePath = next
                    }

                    self.state = .ready(try response.map(GameResponse<Game>.self).results)
                    self.isFetching = false

                } catch {
                    self.state = .error
                }
            case .failure:
                self.state = .error
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: false)
        guard case .ready(let items) = state else { return }
        
        let gameDetailsVC = GameDetailsViewController.instantiate()
        navigationController?.pushViewController(gameDetailsVC, animated: true)
        
    }
}

