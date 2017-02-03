//
//  Episode.swift
//  Ostmodern API
//
//  Created by Laurent Meert on 31/01/17.
//  Copyright © 2017 Laurent Meert. All rights reserved.
//

import Foundation
import CoreData

class Episode {
    
    private var id : String
    private var title : String
    private var synopsis : String
    private var imageUrl : String?
    private var imageData : Data?
    
    init(id : String, title : String, synopsis : String) {
        self.id = id
        self.title = title
        self.synopsis = synopsis
    }
    
    init(entry : NSManagedObject) {
        self.id = entry.value(forKey: DatabaseApi.DatabaseApiConstants.entryId) as! String
        self.title = entry.value(forKey: DatabaseApi.DatabaseApiConstants.entryTitle) as! String
        self.synopsis = entry.value(forKey: DatabaseApi.DatabaseApiConstants.entrySynopsis) as! String
        if let imageUrl = entry.value(forKey: DatabaseApi.DatabaseApiConstants.entryImageUrl) as? String {
            self.imageUrl = imageUrl
        }
        if let imageData = entry.value(forKey: DatabaseApi.DatabaseApiConstants.entryImageData) as? Data {
            self.imageData = imageData
        }
    }
    
    func getId() -> String {
        return self.id
    }
    func getTitle() -> String {
        return self.title
    }
    func getSynopsis() -> String {
        return self.synopsis
    }
    func getImageUrl() -> String? {
        return self.imageUrl
    }
    func getImageData() -> Data? {
        return self.imageData
    }
    
    func setImageUrl(imageUrl : String) {
        self.imageUrl = imageUrl
    }
    func setImageData(imageData : Data) {
        self.imageData = imageData
    }
}
