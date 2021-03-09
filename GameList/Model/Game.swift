//
//  Game.swift
//  GameList
//
//  Created by kobil on 4.03.2021.
//

import Foundation

struct GameResponse:Decodable {
    let results: [Game]
    let next: String?
}

struct Game:Decodable {
    let id:Int?
    let name:String?
    let released:String?
    let rating:Double?
    let background_image:String?
}

