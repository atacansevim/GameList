//
//  GameTableViewCell.swift
//  GameList
//
//  Created by kobil on 5.03.2021.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameRating: UILabel!
    @IBOutlet weak var gameReleased: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
