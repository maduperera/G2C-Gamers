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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        navigationItem.hidesSearchBarWhenScrolling = false
    }

}

