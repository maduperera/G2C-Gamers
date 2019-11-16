//
//  Game.swift
//  G2C Gamers
//
//  Created by Madusha on 11/12/19.
//  Copyright © 2019 Madusha. All rights reserved.
//

import Foundation

public struct Game: Codable {
    let id: Int?
    let name: String?
    let metacritic: Int?
    let background_image: String?
    let genres: [Genre]?
    var favourite: Bool?
    var description: String?
    var webUrl: String?
    var redditUrl: String?
    
    // aggregate the genres to one line
    public static func aggregateGenres(genres: [Game.Genre]) -> String{
        let names = genres.map({ $0.name ?? "" })
        return names.joined(separator: ", ")
    }
    
    public static func decomposeGeneresString(genresString: String) -> [Game.Genre]{
        let genreNames = genresString.components(separatedBy: ",")
        return genreNames.map { Game.Genre(id: nil, name: $0, slug: nil) }
    }
}

extension Game{
    public struct Genre: Codable {
        let id: Int?
        let name: String?
        let slug: String?
    }
}



