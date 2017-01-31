//
//  Episode.swift
//  Ostmodern API
//
//  Created by Laurent Meert on 31/01/17.
//  Copyright © 2017 Laurent Meert. All rights reserved.
//

import Foundation

class Episode {
    
    private var title : String
    private var synopsis : String
    private var imageUrl : String?
    
    init(title : String, synopsis : String) {
        self.title = title
        self.synopsis = synopsis
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
    
    func setImageUrl(imageUrl : String) {
        self.imageUrl = imageUrl
    }
}
