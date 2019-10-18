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
    
//    MARK: - 
    
//    let moc = CoreDataStack.shared.mainContext
    let baseURL: URL = URL(string: "https://lambda-ios-journal.firebaseio.com/")!
    
    init() {
        fetchedEntriesFromServer()
    }
    
    
    
    var entries: [Entry] {
        return self.loadFromPersistentStore()
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
    
    func createEntry(title: String, bodyText: String, mood: Moods, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        let entry = Entry(title: title, bodyText: bodyText, identifier: UUID().uuidString, mood: mood)
        context.perform {
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                print("Unable to save new entry: \(error)")
                context.reset()
            }
        }
        put(entry: entry)
    }
    
    func update(entry: Entry, mood: String, title: String, bodyText: String, timestamp: Date = Date()) {
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timestamp = timestamp
        entry.title = title
    
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
            self.put(entry: entry)
        } catch {
            print("Error saving managed object contect")
        }
    }
    
    func updateEntry(entry: Entry, with representation: JournalEntryRepresentation) {
        entry.mood = representation.mood
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.timestamp = representation.timestamp
    }
    
    func deletedEntry(entry: Entry) {
        
        self.deletedEntry(entry: entry)
        let moc = CoreDataStack.shared.mainContext
        moc.delete(entry)
        
        do {
            try moc.save()
        } catch {
            moc.reset()
            print("Error deleting entry: \(error)")
        }
    }
//    MARK: Server Methods
    
    func put(entry: Entry, completionClosure: @escaping () -> Void =  { }) {
//       create identifier if it doesnt exsist
        let uuid = entry.identifier ?? UUID().uuidString
        
//        let uuid = entry.identifier ?? UUID()
//        set identifier to both entry and representation in case we just created it
//        entry.identifier = uuid
//        respresentation.identifier = uuid
//        save changes to persisitent store
//        saveToPersistentStore()
//
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString)
        .appendingPathComponent("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard var representation = entry.representation else {
                completionClosure()
                return
            }
            representation.identifier = uuid.uuidString
            entry.identifier = uuid
       
            try CoreDataStack.shared.save()
            
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            NSLog("Error enoding entry \(entry): \(error)")
            completionClosure()
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("error PUTting entry to server: \(error)")
                completionClosure()
                return
            }
        completionClosure()
        }.resume()
    }

func deleteFromServer(entry: Entry, completionClosure: @escaping (Error?) -> Void = { _ in}) {
    let uuid = entry.identifier!.uuidString
    let requestURL = baseURL.appendingPathComponent(uuid)
        .appendingPathExtension("json")
    
    var request = URLRequest(url: requestURL)
    request.httpMethod = "DELETE"
    
    URLSession.shared.dataTask(with: request) { (_, result, error) in
        if let error = error {
            print("Error DELETEing from server: \(error)")
            completionClosure(error)
            return
        }
           completionClosure(error)
    }.resume()
}
func fetchedEntriesFromServer(completionClosure: @escaping (Error?) -> Void = { _ in }) {
    let requestURL = baseURL.appendingPathExtension("json")
    
    URLSession.shared.dataTask(with: requestURL) { (data,_, error) in
        if let error = error {
        print("no data returned by data task")
        completionClosure(nil)
        return
    }
        guard let data = data else {
            print("Error fetching entries: \(error)")
            completionClosure(error)
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let dictionaryOfEntries = try decoder.decode([String: JournalEntryRepresentation].self, from: data)
            let representation = Array(dictionaryOfEntries.values)
            try self.updateEntry(with: representation)
            completionClosure(nil)
        } catch {
            print("Error decoding entry representations: \(error)")
            completionClosure(error)
            return
}
}.resume()
}

}
