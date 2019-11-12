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

        // Do any additional setup after loading the view.
    }
    
    static func instantiate() -> GameDetailsViewController {
        guard let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "GameDetailsViewController") as? GameDetailsViewController else { fatalError("Unexpectedly failed getting ComicViewController from Storyboard") }
        
        return vc
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
