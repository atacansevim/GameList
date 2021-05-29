//
//  GameDetailViewController.swift
//  GameList
//
//  Created by kobil on 7.03.2021.
//

import Foundation
import UIKit
import CoreData

class GameDetailViewController:UIViewController{
    private var gameDetailViewModel : GameDetailViewModel!
    var id:Int = 0
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var gameDescription: UILabel!
    @IBOutlet weak var gameMetacritic: UILabel!
    @IBOutlet weak var gameReleaseDate: UILabel!
    override func viewDidLoad() {
        
        Webservice().fetchGameDetail(completaion: { (gameDetail) in
            self.gameDetailViewModel = GameDetailViewModel(gameDetail: gameDetail!)
            DispatchQueue.main.async{
                self.gameDescription.attributedText =  self.convertToAttributeString(htmlText: self.gameDetailViewModel.description!)
                self.gameName.text = self.gameDetailViewModel.name
                self.gameReleaseDate.text = self.gameDetailViewModel.released
                self.gameMetacritic.text = String(self.gameDetailViewModel.metacritic!)
                self.gameImage.kf.setImage(with: URL(string: self.gameDetailViewModel.background_image!))
                self.likeButton.isEnabled = true
            }
        }, id: id)
    }
    
    func convertToAttributeString(htmlText:String)-> NSAttributedString?{
        let encodedData = htmlText.data(using: String.Encoding.utf8)!
        var attributedString: NSAttributedString? = nil

        do {
           attributedString = try NSAttributedString(data: encodedData, options: [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html,NSAttributedString.DocumentReadingOptionKey.characterEncoding:NSNumber(value: String.Encoding.utf8.rawValue)], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("error convert NSstring")
        }
        return attributedString
    }
    
    
    func getFavoriteGames(_name:String) -> Bool{
        
        var flag:Bool = true
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteGames" )
        do{
            let results = try context.fetch(fetchRequest)
            
            for result in results as! [NSManagedObject]{
                
                let name = result.value(forKey: "name") as! String
                if _name.elementsEqual(name) {
                    flag = false
                    break
                }
            }
            return flag
        }catch{
            print("error fetch FavoriteGames")
            return false
        }

    }
    
    @IBAction func likeButtonClick(_ sender: Any) {

        if getFavoriteGames(_name:gameName.text!){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let favoriteGame = NSEntityDescription.insertNewObject(forEntityName: "FavoriteGames", into: context)
            favoriteGame.setValue(self.gameDetailViewModel.name, forKey: "name")
            favoriteGame.setValue(self.gameDetailViewModel.released, forKey: "released")
            favoriteGame.setValue(Double(self.gameDetailViewModel.metacritic!), forKey: "rating")
            favoriteGame.setValue(self.gameDetailViewModel.background_image, forKey: "image")
            do{
                try context.save()
                print("success")
            }catch{
                print("error save favorite game")
            }
        }else{
            print("already added")
        }

    }
    

}
