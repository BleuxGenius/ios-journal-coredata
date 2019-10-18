//
//  Entry+Convience.swift
//  JornalCoreData
//
//  Created by Lambda_School_Loaner_167 on 10/14/19.
//  Copyright © 2019 Dani. All rights reserved.
//

import Foundation
import CoreData

enum Moods: Int, CaseIterable {
    case sad = 0
    case happy = 1
    case crazy = 2
    
    var moodStringValue: String {
        switch self {
        case .sad:
            return "😞"
        case .happy:
            return "😃"
        case .crazy:
            return "🙃"
        }
    }
}


extension Entry {
//    This initializer sets up the Core Data (NSManagedObject) part of the Task,
//    then gives is the properties unique Task entity
    convenience init(title: String, bodyText: String, identifier: String = "", timestamp: Date = Date(), mood: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.title = title
        self.bodyText = bodyText
        self.identifier = identifier
        self.timestamp = timestamp
        self.mood = mood
    }
    
    convenience init(representation: JournalEntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.title = representation.title
        self.bodyText = representation.bodyText
        self.mood = representation.mood
        self.timestamp = representation.timestamp
        self.identifier = representation.identifier
    }
    
    var representation: JournalEntryRepresentation? {
        guard let title = title,
              let mood = mood,
              let bodyText = bodyText,
              let timestamp = timestamp
            else { return nil }
        
        return JournalEntryRepresentation(bodyText: bodyText, identifier: identifier, mood: mood, timestamp: Date(), title: title)
    }
    
}
