//
//  File.swift
//  G2C Gamers
//
//  Created by Madusha on 11/15/19.
//  Copyright © 2019 Madusha. All rights reserved.
//

import Foundation
import SQLite

public class DBHandler{
    
    fileprivate static var generatedInstance: DBHandler?
    var games: Table?
    var db: Connection?
    public static var sharedInstance: DBHandler{
        get{
            if generatedInstance == nil{
                generatedInstance = DBHandler()
            }
            return generatedInstance!
        }
    }
    
    // create db, create table
    private init(){
        
        do{
            
            let documentDerectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create:true)
            let fileUrl = documentDerectory.appendingPathComponent("games").appendingPathExtension("sqlite3")
            
            db = try Connection(fileUrl.path)
            
            games = Table("games")
            let id = Expression<Int>("id")
            let name = Expression<String?>("name")
            let metacritic = Expression<Int>("metacritic")
            let imageUrl = Expression<String>("background_image")
            let genres = Expression<String>("genres")
            let favourite = Expression<Bool>("favourite")

            
            try db?.run(games!.create(ifNotExists: true){ t in
                t.column(id, primaryKey: true)
                t.column(name)
                t.column(metacritic)
                t.column(imageUrl)
                t.column(genres)
                t.column(favourite)
            })
          
        }catch{
            print("db error")
            games = nil
        }
        
    }
    
    // write to table
    public func writeRow(game: Game){
        do{
            let id = Expression<Int>("id")
            let name = Expression<String?>("name")
            let metacritic = Expression<Int>("metacritic")
            let imageUrl = Expression<String>("background_image")
            let genres = Expression<String>("genres")
            let favourite = Expression<Bool>("favourite")
            
            guard let gameId = game.id else {return}
            guard let gameName = game.name else {return}
            guard let gameMetacritic = game.metacritic else {return}
            guard let gameImageUrl = game.background_image else {return}
            guard let gameGenres = game.genres else {return}
            guard let gameFavourite = game.favourite else {return}
            
            let insert = DBHandler.sharedInstance.games!.insert(id <- gameId, name <- gameName, metacritic <- gameMetacritic, imageUrl <- gameImageUrl, genres <- Game.aggregateGenres(genres: gameGenres), favourite <- gameFavourite)
            try DBHandler.sharedInstance.db?.run(insert)
        }catch{print("error in writing to db")}
    }
    
    // read from table
    public func readAll() -> [Game]{
        var gamesArr:[Game] = [Game]()
        do{
            guard let db = DBHandler.sharedInstance.db else {return []}
            let games = try db.prepare("SELECT * FROM games")
            for row in games {
                let game = Game(id: row[0]! as? Int, name: row[1]! as? String, metacritic: row[2]! as? Int, background_image: row[3]! as? String, genres: Game.decomposeGeneresString(genresString: row[4]! as! String), favourite:row[5]! as? Bool, description: nil, webUrl: nil, redditUrl:nil)
                 gamesArr.append(game)
                print("id: \(row[0]!), name: \(row[1]!), favourite: \(row[5]!)")
            }
        }catch{print("error in reading db")}
        return gamesArr
    }
    
    // delete from table
    public func deleteRow(idVal:Int){
        do{
            guard let db = DBHandler.sharedInstance.db else {return}
            let id = Expression<Int>("id")
            let game = Table("games").filter(id == idVal)
            try db.run(game.delete())
        }catch{print("error in db row deletion")}
    }
    
    // read favourite of perticuler game
    public func getPreference(gameId:Int) -> Bool{
        var prefernce: Bool = false
        do{
            let id = Expression<Int>("id")
            let gamesTable = Table("games")
            let favGame = gamesTable.filter(id == gameId)
            guard let sqn = try db?.prepare(favGame) else { return false }
            let games = Array(sqn)
            for game in games {
                prefernce = try game.get(Expression<Bool>("favourite")) ? true : false
            }
        }catch{print("error in reading db")}
        return prefernce
    }
    
    
}
