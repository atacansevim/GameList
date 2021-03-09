//
//  GameDetailViewModel.swift
//  GameList
//
//  Created by kobil on 7.03.2021.
//

import Foundation


struct GameDetailViewModel {
    let gameDetail : GameDetail
    
    var name:String{
        return self.gameDetail.name ?? ""
    }
    var released:String?{
        return self.gameDetail.released ?? ""
    }
    var background_image:String?{
        return self.gameDetail.background_image ?? ""
    }
    var metacritic:Int?{
        return self.gameDetail.metacritic ?? 0
    }
    var description:String?{
        return self.gameDetail.description ?? ""
    }
    
    
}
