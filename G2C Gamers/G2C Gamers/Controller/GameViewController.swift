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
    let pageSize = 10 // default
    var page = 1 // default page starts at 1
    var searchBar:UISearchBar?
    var searchActive = false
    var searchString = ""
    
    // MARK: - View State
    private var state: State = .loading {
        didSet {
            switch state {
            case .ready:
                print(".ready")
                //viewMessage.isHidden = true
                tblGames.isHidden = false
                tblGames.reloadData()
            case .loading:
                print(".loading")
                //viewMessage.isHidden = false
                tblGames.isHidden = true
                //lblMessege.text = "Getting games ..."
                //imgLoading.image = #imageLiteral(resourceName: "mario")
            case .error:
                print(".error")
                //viewMessage.isHidden = false
                //lblMessege.text = """
//                Something went wrong!
//                Try again later.
//                """
//                imgLoading.image = #imageLiteral(resourceName: "mario")
                //tblGames.isHidden = true
            }
        }
    }
    
    
    @IBOutlet weak var tblGames: UITableView!
    @IBOutlet weak var lblMessege: UILabel!
    @IBOutlet weak var imgLoading: UIImageView!
    @IBOutlet weak var viewMessage: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add search bar to the navigation bar
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        navigationItem.hidesSearchBarWhenScrolling = false
        searchBar = navigationItem.searchController?.searchBar
        searchBar?.placeholder = "Search for the games"
        searchBar?.delegate = self
//        navigationItem.searchController?.dismiss(animated: false) {
//             self.navigationController?.pushViewController(UIViewController(), animated: true)
//        }
        
        // we are using min OS 11, but to be sure if the search doesnt give bad side effects
        if #available(iOS 9.1, *) {
            navigationItem.searchController?.obscuresBackgroundDuringPresentation = false
        } else {
            navigationItem.searchController?.dimsBackgroundDuringPresentation = false
        }
        
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
                    self.state = .ready(try response.map(GameRsults<Game>.self).results)
                    self.page = self.page + 1
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
        let cell = tableView.dequeueReusableCell(withIdentifier: GameCell.reuseIdentifier, for: indexPath) as? GameCell ?? GameCell()
        
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        guard let nextPath = nextPagePath else { return }
        if offsetY > contentHeight - scrollView.frame.height * 4{
            if !isFetching{
                fetchNextPage(nextPath: nextPath)
            }
        }
    }
    
    
    func fetchNextPage(nextPath next:String){
        isFetching = true

        //TODO: nice if we can fetch using next path given. Needs to find a way to send Moya string params as it is
        //guard let nextPath = next.components(separatedBy: "io/api").last else {return}
        //print("splitted next : \(next.components(separatedBy: "io/api").last!)")
        
        //fetch game data from next page
        
        var searchText: String?
        
        if searchActive  {
            searchText = searchString
        }
        
        provider.request(.nextGames(pageSize:pageSize, page:page, searchString:searchText)) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                do {
                    self.isFetching = false
                    guard case .ready(var items) = self.state else { return }
                    let arr: [Game] = try response.map(GameRsults<Game>.self).results
                    // if the page doesnt have any Game details move on to the next
                    if arr.count == 0 {return}
                    items.append(contentsOf: arr)
                    self.state = .ready(items)
                    print("success page number : \(self.page)")
                    self.page = self.page + 1
                } catch {
                    print("we can safely ignore this")
                }
            case .failure:
                print("out of content")
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gameDetailsVC = GameDetailsViewController.instantiate()
        navigationController?.pushViewController(gameDetailsVC, animated: true)
        
    }
}


extension GameViewController: UISearchBarDelegate{
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        guard case .ready(var items) = self.state else { return }
        items.removeAll()
        self.state = .ready(items)
        page = 1
        fetchNextPage(nextPath: "")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchActive = true
        searchString = searchText
        // search querry needs to be at least 4 letter word
        if searchText.count < 4 { return }
        guard case .ready(var items) = self.state else { return }
        items.removeAll()
        self.state = .ready(items)
        page = 1
        // fetch game search data
        provider.request(.nextGames(pageSize:pageSize, page:page, searchString:searchText)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    let arr = try response.map(GameRsults<Game>.self).results
                    self.state = .ready(arr)
                } catch {
                    self.state = .error
                }
            case .failure:
                self.state = .error
            }
        }
    }
}
