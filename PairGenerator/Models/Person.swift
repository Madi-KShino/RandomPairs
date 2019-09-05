//
//  Person.swift
//  PairGenerator
//
//  Created by Madison Kaori Shino on 9/4/19.
//  Copyright © 2019 Madi S. All rights reserved.
//

import Foundation
import CloudKit

class Person {
   
    //CLASS PROPERTIES
    var name: String
    var ckRecordID: CKRecord.ID
    
    //DESIGNATED INITIALIZER
    init(name: String, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.name = name
        self.ckRecordID = ckRecordID
    }
    
    //RECORD -> MODEL OBJECT INITIALIZER
    convenience init?(record: CKRecord) {
        guard let name = record[PersonConstants.nameKey] as? String else { return nil }
        self.init(name: name, ckRecordID: record.recordID)
    }
}

//MODEL OBJECT -> RECORD INITIALIZER
extension CKRecord {
    convenience init(person: Person) {
        self.init(recordType: PersonConstants.typeKey, recordID: person.ckRecordID)
        self.setValue(person.name, forKey: PersonConstants.nameKey)
    }
}

//CONFORM TO EQUATABLE FOR DELETING
extension Person: Equatable {
    static func ==(lhs: Person, rhs: Person) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
}

//STRING CONSTANTS FOR CLOUDKIT KEYS
struct PersonConstants {
    static let typeKey = "Person"
    fileprivate static let nameKey = "name"
}
