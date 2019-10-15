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
    
    let moc = CoreDataStack.shared.mainContext
    
    var entries: [Entry] {
        return self.loadFromPersistentStore()
    }
        
    func saveToPersistentStore() {
        do {
            try moc.save()
        } catch {
            print("Error saving: \(error)")
        }
    }

    func loadFromPersistentStore() -> [Entry] {
        let fetchRequest: NSFetchRequest<Entry> =
        Entry.fetchRequest()
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            print("Error fetching: \(error)")
            return []
        }
    }
    
    func createEntry(title: String, bodyText: String) {
        let createdEntry = Entry(title: title, bodyText: bodyText)
        saveToPersistentStore()
    }
    
    func updateEntry(entry: Entry, newTitle: String, newBody: String) {
        guard !newTitle.isEmpty else {return}
        entry.title = newTitle
        entry.bodyText = newBody
        entry.timestamp = Date()
        saveToPersistentStore()
    }
    
    func deletedEntry(entry: Entry) {
        moc.delete(entry)
        
        do {
            try moc.save()
        } catch {
            moc.reset()
            print("Error deleting entry: \(error)")
        }
    }
    
}
