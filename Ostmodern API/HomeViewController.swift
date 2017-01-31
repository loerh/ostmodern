//
//  ViewController.swift
//  Ostmodern API
//
//  Created by Laurent Meert on 31/01/17.
//  Copyright © 2017 Laurent Meert. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CellImageDelegate {
    
    private lazy var episodes = [Episode]()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var epTableView: UITableView! {
        didSet {
            let request = ApiRequest()
            request.taskUrl = ApiRequest.ApiRequestConstants.HomeSetUrl
            request.cellImageDelegate = self
            request.fetch() { result in
                self.episodes = result
                self.epTableView.reloadData()
                self.activityIndicator.stopAnimating()
                
                Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { (timer) in
                    print("firing timer!")
                    self.episodes.append(Episode(title: "Test ep", synopsis: "test syn"))
                    self.epTableView.beginUpdates()
                    self.epTableView.insertRows(at: [IndexPath(row: self.episodes.count-1, section: 0)], with: .automatic)
                    self.epTableView.endUpdates()
                })
            }
        }
    }
    
    //MARK: TABLEVIEW
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? EpisodeTableViewCell {
            cell.epTitleLabel.text = self.episodes[indexPath.row].getTitle()
            cell.epSynopsisLabel.text = self.episodes[indexPath.row].getSynopsis()
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.episodes.count
    }
    
    //MARK: NEW CELL DELEGATE
    
    func didLoadCellImage(row: Int, episode: Episode) {
        let cell = self.epTableView.cellForRow(at: IndexPath(row: row, section: 0)) as? EpisodeTableViewCell
        
                let url = episode.getImageUrl()
            URLSession.shared.dataTask(with: URL(string: url!)!, completionHandler: { (data, response, error) in
                if (data != nil) {
                    DispatchQueue.main.async {
                        cell?.epImageView.image = UIImage(data: data!)
                        self.epTableView.reloadData()
                    }
                }
            }).resume()
        
    }
}

