//
//  Request.swift
//  Ostmodern API
//
//  Created by Laurent Meert on 31/01/17.
//  Copyright © 2017 Laurent Meert. All rights reserved.
//

import Foundation
import SwiftyJSON

class ApiRequest {
    
    private struct ApiRequestPrivateConstants {
        static let BaseUrl = "http://feature-code-test.skylark-cms.qa.aws.ostmodern.co.uk:8000"
    }
    struct ApiRequestConstants {
        static let HomeSetUrl = "/api/sets/?slug=home"
    }
    
    var taskUrl : String?
    var cellImageDelegate : CellImageDelegate?
    
    func fetch(completion : @escaping (_ episodes : [Episode]) -> Void) {
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            self.executeTask(taskUrl: ApiRequestConstants.HomeSetUrl) { (json) in
                self.homeSetDidFetch(fromJson: json) {
                    DispatchQueue.main.async {
                        completion(self.episodes)
                    }
                }
            }
        }
    }
    
    private func executeTask(taskUrl: String, completion: @escaping (_ json: JSON) -> Void) {
        
        if (self.taskUrl != nil) {
            let task = URLSession.shared.dataTask(with: URL(string: "\(ApiRequestPrivateConstants.BaseUrl)\(taskUrl)")!) { (data, response, error) in
                if error == nil && data != nil {
                    let json = JSON(data: data!)
                    completion(json)
                } else if error != nil {
                    print(error!)
                }
            }
            task.resume()
        }
    }
    
    private func homeSetDidFetch(fromJson json : JSON, completion: @escaping () -> Void) {
        
        if let objects = json["objects"][0]["items"].array {
            for i in 0..<objects.count {
                let object = objects[i]
                if let contentUrl = object["content_url"].string {
                    self.executeTask(taskUrl: contentUrl, completion: { (json) in
                        print(json)
                        self.contentDidFetch(fromJson: json) {
                            if (i == objects.count-1) {
                                completion()
                            }
                        }
                    })
                } else {
                    print("no content URL for id \(object["uid"])!")
                }
            }
        }
    }
    
    private var episodes = [Episode]()
    
    private func contentDidFetch(fromJson json : JSON, completion : () -> Void) {
        print(json)
        if let title = json["title"].string, let synopsis = json["synopsis"].string {
            self.episodes.append(Episode(title: title, synopsis: synopsis))
            print(json)
            if let imageUrl = json["image_urls"][0].string {
                
                DispatchQueue.global(qos: .background).async {
                    self.executeTask(taskUrl: imageUrl, completion: { (json) in
                        DispatchQueue.main.async {
                            self.imageDidFetch(fromJson: json, withEpisode: self.episodes[self.episodes.count-1], atPosition: self.episodes.count-1)
                        }
                    })
                }
            }
            completion()
        }
    }
    
    private func imageDidFetch(fromJson json : JSON, withEpisode episode : Episode, atPosition position : Int) {
        if let url = json["url"].string {
            episode.setImageUrl(imageUrl: url)
            self.cellImageDelegate?.didLoadCellImage(row: position, episode: episode)
        }
    }
    
}
