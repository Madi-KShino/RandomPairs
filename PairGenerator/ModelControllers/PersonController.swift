//
//  PersonController.swift
//  PairGenerator
//
//  Created by Madison Kaori Shino on 9/5/19.
//  Copyright © 2019 Madi S. All rights reserved.
//

import Foundation
import CloudKit

class PersonController {
    
    //PROPERTIES
    static let shared = PersonController()
    private let database = CKContainer.default().publicCloudDatabase
    
    //CREATE
    func savePerson(withName name: String, completion: @escaping(Person?) -> Void) {
        let person = Person(name: name)
        let record = CKRecord(person: person)
        database.save(record) { (record, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) \n---\n \(error)")
                completion(nil)
                return
            }
            guard let record = record else { completion(nil); return }
            let person = Person(record: record)
            completion(person)
        }
    }
    
    //READ
    func fetchPeople(completion: @escaping([Person]?) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: PersonConstants.typeKey, predicate: predicate)
        database.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) \n---\n \(error)")
                completion(nil)
                return
            }
            guard let records = records else { completion(nil); return }
            let people: [Person] = records.compactMap({Person(record: $0)})
            completion(people)
        }
    }
    
    //DELETE
    func delete(person: Person, completion: @escaping(Bool) -> Void) {
        database.delete(withRecordID: person.ckRecordID) { (recordID, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            completion (true)
        }
    }
}
