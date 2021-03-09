//
//  GameService.swift
//  GameList
//
//  Created by kobil on 4.03.2021.
//

import Foundation
import Alamofire
import SwiftyJSON

class Webservice{
    
    let apiKey = "7e8325de33mshc7923f5a9c8e3b7p1475f7jsn4c3c4c8832c7"
    func fetchGames(completaion:@escaping(GameResponse?) -> ()){
        let url = "https://rawg-video-games-database.p.rapidapi.com/games"
        let headers = [
            "x-rapidapi-key": apiKey,
            "x-rapidapi-host": "rawg-video-games-database.p.rapidapi.com"
        ] as HTTPHeaders
        AF.request(url, method: .get,headers: headers).response{(response) in
            switch response.result{
            case .success(let data):
                let gameList = try? JSONDecoder().decode(GameResponse.self, from: (data)!)
                completaion(gameList)
                break
            case .failure(let data):
                completaion(nil)
                break
        }
    }
    }
    
    func fetchGameDetail(completaion:@escaping(GameDetail?) -> (),id:Int){
        let url =  "https://rawg-video-games-database.p.rapidapi.com/games/" + String(id)
        let headers = [
            "x-rapidapi-key": apiKey,
            "x-rapidapi-host": "rawg-video-games-database.p.rapidapi.com"
        ] as HTTPHeaders
        AF.request(url, method: .get,headers: headers).response{(response) in
            switch response.result{
            case .success(let data):
                let gameDetail = try? JSONDecoder().decode(GameDetail.self, from: (data)!)
                completaion(gameDetail)
                break
            case .failure(let _):
                completaion(nil)
                break
        }
    }
    }
}



