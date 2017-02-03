//
//  DetailViewController.swift
//  Ostmodern API
//
//  Created by Laurent Meert on 01/02/17.
//  Copyright © 2017 Laurent Meert. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, BarButtonImageDelegate {
    
    @IBOutlet weak var epImageView: UIImageView!
    @IBOutlet weak var epTitleLabel: UILabel!
    @IBOutlet weak var epSynopsisLabel: UILabel!
    
    var passedEpisode : Episode?
    var favoriteDelegate : EpisodeFavoriteDelegate?
    private lazy var userDefaultsApi = UserDefaultsApi()
    private lazy var favBarButtonItem = FavoriteBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Episode Details"
        
        if let episode = self.passedEpisode {
            self.epTitleLabel.text = episode.getTitle()
            self.epSynopsisLabel.text = episode.getSynopsis()
            if let data = episode.getImageData() {
                self.epImageView.image = UIImage(data: data)
            } else {
                self.epImageView.image = UIImage(named: "no-image")
            }
            self.favBarButtonItem.imageDelegate = self
        }
        
        self.navigationItem.rightBarButtonItem = self.favBarButtonItem
    }
    
    
    //MARK: IMAGE DELEGATE
    
    func shouldChangeImage() -> Bool {
        if let episode = self.passedEpisode {
            return self.userDefaultsApi.isFavorite(uniqueId: episode.getId())
        }
        return false
    }
    func willUpdateFavorite() {
        if let episode = self.passedEpisode,
            let delegate = self.favoriteDelegate {
            self.userDefaultsApi.updateFavorite(uniqueId: episode.getId())
            delegate.didUpdateFavorite()
        }
    }
    
    
}
