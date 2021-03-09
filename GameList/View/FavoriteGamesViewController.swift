//
//  FavoriteGamesViewController.swift
//  GameList
//
//  Created by kobil on 9.03.2021.
//

import Foundation
import UIKit
import CoreData
import Kingfisher

class FavoriteGamesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    var favoriteGame = [Game]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewWillAppear(_ animated: Bool) {
        tableView.delegate = self
        tableView.dataSource = self
        favoriteGame.removeAll()
        getFavoriteGames()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteGame.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell",for: indexPath) as! GameTableViewCell
        cell.gameName.text = favoriteGame[indexPath.row].name
        cell.gameRating.text = String(favoriteGame[indexPath.row].rating ?? 0.0)
        cell.gameReleased.text = favoriteGame[indexPath.row].released
        cell.gameImage.kf.setImage(with: URL(string: favoriteGame[indexPath.row].background_image!))
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            deleteFromCoreData(name:favoriteGame[indexPath.row].name!,index: indexPath.row)
        }
    }
    
    func getFavoriteGames(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteGames" )
        do{
            let results = try context.fetch(fetchRequest)
            
            for result in results as! [NSManagedObject]{
                let favGame = Game.init(id: nil, name: result.value(forKey: "name") as? String, released: result.value(forKey: "released") as? String, rating: result.value(forKey: "rating") as? Double, background_image: result.value(forKey: "image") as? String)
                favoriteGame.append(favGame)
                self.tableView.reloadData()
            }
        }catch{
            print("error fetch FavoriteGames")
        }

    }
    
    func deleteFromCoreData(name:String,index:Int)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteGames" )
        fetchRequest.predicate = NSPredicate(format: "name = %@", name)
        do{
            let results = try context.fetch(fetchRequest)
            
            for result in results as! [NSManagedObject]{
                if name == result.value(forKey:"name" )as! String{
                    context.delete(result)
                    favoriteGame.remove(at: index)
                    self.tableView.reloadData()
                    do{try context.save()
                        
                    }catch{
                        print("error delete FavoriteGames")
                    }
                    break
                }
            }
        }catch{
            print("error fetch FavoriteGames")
        }
    }
    

}


