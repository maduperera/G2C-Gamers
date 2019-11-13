//
//  CodableResponse.swift
//  G2C Gamers
//
//  Created by Madusha on 11/12/19.
//  Copyright © 2019 Madusha. All rights reserved.
//

import Foundation

struct GameRsults<T: Codable>: Codable {
    let results: [T]
}

struct GameResponse<T: Codable>: Codable {
    let genres: GameRsults<T>
}
