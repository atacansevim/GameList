//
//  GameDetaild.swift
//  GameList
//
//  Created by kobil on 7.03.2021.
//

import Foundation


struct GameDetail:Decodable {
    let name:String?
    let description:String?
    let metacritic:Int?
    let released:String?
    let background_image:String?
}
