//
//  Entry+Convience.swift
//  JornalCoreData
//
//  Created by Lambda_School_Loaner_167 on 10/14/19.
//  Copyright © 2019 Dani. All rights reserved.
//

import Foundation
import CoreData

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
}
