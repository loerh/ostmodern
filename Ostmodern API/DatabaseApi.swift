//
//  DatabaseApi.swift
//  Ostmodern API
//
//  Created by Laurent Meert on 01/02/17.
//  Copyright © 2017 Laurent Meert. All rights reserved.
//

import Foundation
import CoreData

class DatabaseApi {
    
    struct DatabaseApiConstants {
        static let entityEpisode : String = "OMEpisode"
        static let entryId : String = "uid"
        static let entryTitle : String = "title"
        static let entrySynopsis : String = "synopsis"
        static let entryImageUrl : String = "imageUrl"
        static let entryImageData : String = "imageData"
    }
    private var managedContext : NSManagedObjectContext
    private lazy var data = [NSManagedObject]()
    
    init(delegate : AppDelegate) {
        self.managedContext = delegate.persistentContainer.viewContext
    }
    
    //MARK: FETCH EPISODE ENTRIES
    
    func fetchEntries() -> [NSManagedObject] {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DatabaseApiConstants.entityEpisode)
        do {
            let results = try self.managedContext.fetch(fetchRequest)
            self.data = results as! [NSManagedObject]
        } catch let error as NSError {
            print(error.description)
        }
        
        return self.data
    }
    
    //MARK: SAVE EPISODE ENTRY
    
    func saveEntry(episode : Episode) {
        var entry : NSManagedObject!
        if let existingEntry = self.fetchEntry(withEpisodeId: episode.getId()) {
            entry = existingEntry
        } else {
            let entity = NSEntityDescription.entity(forEntityName: DatabaseApiConstants.entityEpisode, in: self.managedContext)
            entry = NSManagedObject(entity: entity!, insertInto: self.managedContext)
        }
        
        entry.setValue(episode.getId(), forKey: DatabaseApiConstants.entryId)
        entry.setValue(episode.getTitle(), forKey: DatabaseApiConstants.entryTitle)
        entry.setValue(episode.getSynopsis(), forKey: DatabaseApiConstants.entrySynopsis)
        if let url = episode.getImageUrl() {
            entry.setValue(url, forKey: DatabaseApiConstants.entryImageUrl)
        }
        if let data = episode.getImageData() {
            entry.setValue(data, forKey: DatabaseApiConstants.entryImageData)
        }
        
        do
        {
            try self.managedContext.save()
            self.data.append(entry)
        }
        catch let error as NSError
        {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    private func fetchEntry(withEpisodeId id : String) -> NSManagedObject? {
        for entry in self.fetchEntries() {
            if let uid = entry.value(forKey: DatabaseApiConstants.entryId) as? String {
                if uid == id {
                    return entry
                }
            }
        }
        return nil
    }
    
    private func clearData() {
        self.data.removeAll()
    }
    
    func deleteAllEntries() {
        for entry in self.fetchEntries() {
            self.managedContext.delete(entry)
        }
        do {
            try self.managedContext.save()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    
}
