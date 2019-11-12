//
//  Games.swift
//  G2C Gamers
//
//  Created by Madusha on 11/12/19.
//  Copyright © 2019 Madusha. All rights reserved.
//

import Foundation
import Moya

public enum G2C {
    case games
    case nextGames(nextPath:String)
}

extension G2C: TargetType {
    
    public var baseURL: URL {
        return URL(string: "https://api.rawg.io/api")!
    }
    
    public var path: String {
        switch self {
        case .games: return "/games"
        case .nextGames(let nextPath):
            print("passed : \(nextPath)")
            //return nextPath
            return "/games"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .games: return .get
        case .nextGames: return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        //return .requestPlain
        
        //let pageParams = ["size": 10, "page": 1]
        
        switch self {
            case .games:
                return .requestParameters(
                    parameters: [
                        "page_size": "10",
                        "page": "1"],
                    encoding: URLEncoding.default)
            case .nextGames:
                return .requestParameters(
                    parameters: [
                        "page_size": "10",
                        "page": "2"],
                    encoding: URLEncoding.default)
        }
        
    }
    
    public var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
}

