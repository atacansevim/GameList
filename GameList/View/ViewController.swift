//
//  ViewController.swift
//  GameList
//
//  Created by kobil on 4.03.2021.
//

import UIKit


import Alamofire
import SwiftyJSON
import Kingfisher


class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    private var gameListViewModel : GameListViewModel!
    private var filteredGameList : [Game]? = nil
    private var currentGameList : [Game]? = nil
    private var searching = false
    private var counter = 0
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sliderColletionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        sliderColletionView.delegate = self
        sliderColletionView.dataSource = self
        searchBar.delegate = self
        Webservice().fetchGames { (game) in
        
            self.gameListViewModel = GameListViewModel(gameList: game?.results)
            self.currentGameList = self.gameListViewModel.gameList
            DispatchQueue.main.async{ [self] in
                self.tableView.reloadData()
                self.sliderColletionView.reloadData()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentGameList == nil ? 0 : currentGameList?.count as! Int
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell",for: indexPath) as! GameTableViewCell
            cell.gameName.text = currentGameList![indexPath.row].name
            cell.gameRating.text = String(currentGameList![indexPath.row].rating ?? 0.0)
            cell.gameReleased.text = currentGameList![indexPath.row].released
            cell.gameImage.kf.setImage(with: URL(string: currentGameList![indexPath.row].background_image!))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "toGameDetail", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? GameDetailViewController
        {
            destination.id = (currentGameList![(tableView.indexPathForSelectedRow?.row)!].id)!
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
        }
        
        
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.gameListViewModel == nil ? 0 : self.gameListViewModel.numberOfSection() > 3 ? 3 : self.gameListViewModel.numberOfSection()    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderColletionViewCell", for: indexPath) as! SliderColletionViewCell
        let gameViewModel = self.gameListViewModel.gameAtIndex(_index: indexPath.row)

            cell.sliderImageView.kf.setImage(with: URL(string: gameViewModel.background_image!))
        cell.sizeToFit()
        return cell
    }
}

extension ViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:0,left: 0,bottom: 0,right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = sliderColletionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
}

extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty || searchText.count < 3 {
            currentGameList = gameListViewModel.gameList
            sliderColletionView.isHidden = false
            tableView.isHidden = false
            tableView.reloadData()
        }else
        {
            sliderColletionView.isHidden = true
            currentGameList = gameListViewModel.gameList?.filter({ (Game) -> Bool in
                return (Game.name?.lowercased().contains(searchText.lowercased()))!
            })
            if currentGameList?.count == 0{
                tableView.isHidden = true
            }
            tableView.reloadData()
        }
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
}

