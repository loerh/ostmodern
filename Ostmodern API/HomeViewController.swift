//
//  ViewController.swift
//  Ostmodern API
//
//  Created by Laurent Meert on 31/01/17.
//  Copyright © 2017 Laurent Meert. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EpisodeFavoriteDelegate {
    
    private lazy var episodes = [Episode]()
    private lazy var requestApi = RequestApi()
    private lazy var userDefaultsApi = UserDefaultsApi()
    private lazy var dbApi = DatabaseApi(delegate: UIApplication.shared.delegate as! AppDelegate)
    private var selectedRow : Int!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loaderView: UIView!
    
    @IBOutlet weak var epTableView: UITableView! {
        didSet {
            
            self.fetchFromCoreData {
                self.epTableView.reloadData()
            }
            self.willFetchFromNetwork()
        }
    }
    
    //MARK: OTHER FUNCTIONS
    
    private func willFetchFromNetwork() {
        if (Reachability.isConnectedToNetwork()) {
            self.requestApi.taskUrl = RequestApi.ApiRequestConstants.homeSetUrl
            self.requestApi.fetch() { result in
                self.episodes = result
                self.epTableView.reloadData()
                self.saveToCoreData()
                self.loaderView.isHidden = true
                self.activityIndicator.stopAnimating()
            }
        } else {
            Alert.networkDidFailToConnect(viewController: self)
            self.loaderView.isHidden = true
            self.activityIndicator.stopAnimating()
        }

    }
    
    private func fetchFromCoreData(_ completion : () -> Void) {
        self.episodes.removeAll()
        let data = self.dbApi.fetchEntries()
        for entry in data {
            self.episodes.append(Episode(entry: entry))
        }
        self.episodes.sort {$0.getTitle() < $1.getTitle()}
        completion()
    }
    
    private func saveToCoreData() {
        self.dbApi.deleteAllEntries()
        for episode in self.episodes {
            self.dbApi.saveEntry(episode: episode)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "episodeDetail" {
            let destination = segue.destination as! DetailViewController
            destination.passedEpisode = self.episodes[self.selectedRow]
            destination.favoriteDelegate = self
        }
    }
    
    //MARK: TABLEVIEW
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? EpisodeTableViewCell {
            let episode = self.episodes[indexPath.row]
            cell.id = episode.getId()
            cell.epTitleLabel.text = episode.getTitle()
            cell.epSynopsisLabel.text = episode.getSynopsis()
            if let imageData = self.episodes[indexPath.row].getImageData() {
                    cell.epImageView.image = UIImage(data: imageData)
            } else {
                cell.epImageView.image = UIImage(named: "no-image")
            }
            if self.userDefaultsApi.getFavorites().contains(episode.getId()) {
                cell.favImageView.image = UIImage(named: "favicon-enabled")
                cell.favorite = true
            } else {
                cell.favImageView.image = UIImage(named: "favicon-disabled")
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.episodes.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row
        self.performSegue(withIdentifier: "episodeDetail", sender: self)
    }
    
    @IBAction func updateFavorite(_ sender: UIControl) {
        if let cell = sender.superview?.superview as? EpisodeTableViewCell,
            let indexPath = self.epTableView.indexPath(for: cell) {
            cell.updateFavIcon()
            self.userDefaultsApi.updateFavorite(uniqueId: self.episodes[indexPath.row].getId())
        }
    }
    
    
    //MARK: FAVORITE DELEGATE
    
    func didUpdateFavorite() {
        self.epTableView.reloadData()
    }
}

