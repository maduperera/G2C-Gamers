//
//  Game.swift
//  G2C Gamers
//
//  Created by Madusha on 11/12/19.
//  Copyright © 2019 Madusha. All rights reserved.
//

import Foundation

struct Game: Codable {
    let id: Int?
    let name: String?
    let metacritic: Int?
    let background_image: String?
    let genres: [Genre]?
    let favourite = false
}

extension Game{
    struct Genre: Codable {
        let id: Int?
        let name: String?
        let slug: String?
    }
}

