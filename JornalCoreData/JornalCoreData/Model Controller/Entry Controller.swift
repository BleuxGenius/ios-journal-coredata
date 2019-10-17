//
//  Entry Controller.swift
//  JornalCoreData
//
//  Created by Lambda_School_Loaner_167 on 10/15/19.
//  Copyright © 2019 Dani. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    
    
    var entries: [Entry] {
        return self.loadFromPersistentStore()
    }
        
    func saveToPersistentStore() {
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            print("Error saving: \(error)")
        }
    }

    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> =
        Entry.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            print("Error fetching: \(error)")
            return []
        }
    }
    
    func createEntry(title: String, bodyText: String, mood: String) {
        let _ = Entry(title: title, bodyText: bodyText, mood: mood)
        saveToPersistentStore()
    }
    
    func updateEntry(title: String, bodyText: String, mood: String, entry: Entry) {
    
        entry.title = title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood
        saveToPersistentStore()
    }
    
    func deletedEntry(entry: Entry) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        
        do {
            try moc.save()
        } catch {
            moc.reset()
            print("Error deleting entry: \(error)")
        }
    }
    
}
