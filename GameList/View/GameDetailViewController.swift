//
//  GameDetailViewController.swift
//  GameList
//
//  Created by kobil on 7.03.2021.
//

import Foundation
import UIKit
import Kingfisher


class GameDetailViewController:UIViewController{
    private var gameDetailViewModel : GameDetailViewModel!
    var id:Int = 0
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
            print("error")
        }
        return attributedString
    }

}
