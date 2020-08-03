//
//  Persistance.swift
//  Dog breeds
//
//  Created by Александр Осипов on 03.08.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import Foundation
import RealmSwift

class Persistance {
    
    static var shared = Persistance()
    private let realm = try! Realm()
    
    func writeModel(breedStr: String, subbreedStr: String?, imageURLStr: String) {
        try! realm.write {
            
            var fullBread = breedStr
            
            if let subbreed = subbreedStr {
                fullBread += " \(subbreed)"
            }
            
            if let newBreed = realm.objects(BreedRealm.self).filter("breed == '\(fullBread)'").first {
                let newImageURL = BreedImageRealm()
                newImageURL.imageURL = imageURLStr
                newBreed.image.append(newImageURL)
                realm.add(newBreed)
            } else {
                let newBreed = BreedRealm()
                newBreed.breed = fullBread
                let newImageURL = BreedImageRealm()
                newImageURL.imageURL = imageURLStr
                newBreed.image.append(newImageURL)
                realm.add(newBreed)
            }
            
            realm.refresh()
        }
    }
    
    func readModel() -> [BreedRealm]? {
        
        let object: [BreedRealm]?
        
        object = realm.objects(BreedRealm.self).filter("#image.@count > 0").array
        
        return object
    }
    
    func readImage(imageURL: String) -> Bool {
        
        if realm.objects(BreedImageRealm.self).filter("imageURL == '\(imageURL)'").count == 0 {
            return false
        } else {
            return true
        }
    }
    
    func deleteModel(imageURL: String) {
        guard let record = realm.objects(BreedImageRealm.self).filter("imageURL == '\(imageURL)'").first else { return }
        try! realm.write {
            realm.delete(record)
            realm.refresh()
        }
    }
    
}
extension List {
    var array: [Element] {
        return self.count > 0 ? self.map { $0 } : []
    }
    
    func toArray<T>(ofType: T.Type) -> [T] {
            var array = [T]()
            for i in 0 ..< count {
                if let result = self[i] as? T {
                    array.append(result)
                }
            }
            return array
        }
}

extension Results {
    var array: [Element] {
        return self.count > 0 ? self.map { $0 } : []
    }
}
