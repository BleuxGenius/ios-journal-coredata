//
//  JournalEntryRepresentation.swift
//  JornalCoreData
//
//  Created by Lambda_School_Loaner_167 on 10/17/19.
//  Copyright © 2019 Dani. All rights reserved.
//

import Foundation


struct JournalEntryRepresentation: Codable {
    
    var bodyText: String?
    var identifier: String?
    var mood: String
    var timestamp: Date
    var title: String
}
