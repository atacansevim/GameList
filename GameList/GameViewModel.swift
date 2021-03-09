//
//  GameViewModel.swift
//  GameList
//
//  Created by kobil on 5.03.2021.
//

import Foundation


struct GameListViewModel{
    let gameList : [Game]
    
    func numberOfSection() ->Int{
        return self.gameList.count
    }
    
    func gameAtIndex(_index:Int) -> GameViewModel{
        let game = self.gameList[_index]
        return GameViewModel(game: game)
    }
}

struct GameViewModel {
    let game : Game
    
    var id:Int{
        return self.game.id ?? 0
    }
    
    var name:String{
        return self.game.name ?? ""
    }
    
    var rating:Double?{
        return self.game.rating ?? 0.0
    }
    var released:String?{
        return self.game.released ?? ""
    }
    var background_image:String?{
        return self.game.background_image ?? ""
    }
    
}
