//
//  Request.swift
//  Ostmodern API
//
//  Created by Laurent Meert on 31/01/17.
//  Copyright © 2017 Laurent Meert. All rights reserved.
//

import Foundation
import SwiftyJSON

class RequestApi {
    
    private struct ApiRequestPrivateConstants {
        static let baseUrl = "http://feature-code-test.skylark-cms.qa.aws.ostmodern.co.uk:8000"
    }
    struct ApiRequestConstants {
        static let homeSetUrl = "/api/sets/?slug=home"
    }
    
    var taskUrl : String?
    
    
    func fetch(completion : @escaping (_ episodes : [Episode]) -> Void) {
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            self.executeTask(taskUrl: ApiRequestConstants.homeSetUrl) { (json) in
                self.homeSetDidFetch(fromJson: json) {
                    DispatchQueue.main.async {
                        completion(self.episodes.sorted {$0.getTitle() < $1.getTitle()})
                    }
                }
            }
        }
    }
    
    private func executeTask(taskUrl: String, completion: @escaping (_ json: JSON) -> Void) {
        
        if (self.taskUrl != nil) {
            let task = URLSession.shared.dataTask(with: URL(string: "\(ApiRequestPrivateConstants.baseUrl)\(taskUrl)")!) { (data, response, error) in
                if error == nil && data != nil {
                    let json = JSON(data: data!)
                    completion(json)
                } else if error != nil {
                    print(error!)
                }
                if let httpResponse = response as? HTTPURLResponse {
                    switch (httpResponse.statusCode) {
                    case 100..<200: print("Informational")
                    case 200..<300: print("Success")
                    case 300..<400: print("Redirection")
                    case 400..<500: print("Client Error")
                    case 500..<600: print("Server Error")
                    default:
                        break
                    }
                }
            }
            task.resume()
        }
    }
    
    private func homeSetDidFetch(fromJson json : JSON, completion: @escaping () -> Void) {
        
        if let objects = json["objects"][0]["items"].array {
            
            var tasksCompleted = 0
            
            for i in 0..<objects.count {
                let object = objects[i]
                if let contentUrl = object["content_url"].string {
                    self.executeTask(taskUrl: contentUrl, completion: { (json) in
                        self.contentDidFetch(fromJson: json, atPosition: i, withCount : objects.count) {
//                            if (i == objects.count-1) {
//                                completion()
//                            }
                            tasksCompleted += 1
                            if (tasksCompleted == objects.count) {
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
    
    private func contentDidFetch(fromJson json : JSON, atPosition position : Int, withCount count : Int, completion : @escaping () -> Void) {
        var finalId = "no_id"
        var finalTitle = "no_title"
        var finalSynopsis = "no_synopsis"
        if let id = json["uid"].string {
            finalId = id
        }
        if let title = json["title"].string {
            finalTitle = title
        }
        if let synopsis = json["synopsis"].string {
            finalSynopsis = synopsis
        }
        
        self.episodes.append(Episode(id: finalId, title: finalTitle, synopsis: finalSynopsis))
        if let imageUrl = json["image_urls"][0].string {
            
            self.executeTask(taskUrl: imageUrl) { (json) in
                self.imageDidFetch(fromJson: json, withEpisode: self.episodes[position], atPosition: position) {
                    completion()
                }
            }
        } else {
            completion()
        }
        
    }
    
    private func imageDidFetch(fromJson json : JSON, withEpisode episode : Episode, atPosition position : Int, completion : @escaping () -> Void) {
        if let url = json["url"].string {
            episode.setImageUrl(imageUrl: url)
            self.getImageData(fromUrl: episode.getImageUrl()!) { (data) in
                episode.setImageData(imageData: data)
                completion()
            }
//            self.cellImageDelegate?.didLoadCellImage(row: position, episode: episode)
    
        }
    }
    
    private func getImageData(fromUrl url : String, completion: @escaping (_ data: Data) -> Void) {
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            completion(data ?? Data())
        }.resume()
    }
}
