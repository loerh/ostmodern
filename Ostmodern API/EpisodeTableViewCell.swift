//
//  EpisodeTableViewCell.swift
//  Ostmodern API
//
//  Created by Laurent Meert on 31/01/17.
//  Copyright © 2017 Laurent Meert. All rights reserved.
//

import UIKit

class EpisodeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var epImageView: UIImageView!
    @IBOutlet weak var favImageView: UIImageView!
    @IBOutlet weak var epTitleLabel: UILabel!
    @IBOutlet weak var epSynopsisLabel: UILabel!
    
    var id : String?
    
    var favorite = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.favImageView.image = UIImage(named: "favicon-disabled")
        self.epImageView.image = UIImage(named: "no-image")
        self.epImageView.layer.cornerRadius = 5
        self.epImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func updateFavIcon() {
        self.favorite = !self.favorite
        if self.favorite {
            self.favImageView.image = UIImage(named: "favicon-enabled")
        } else {
            self.favImageView.image = UIImage(named: "favicon-disabled")
        }
    }
    
    
}
