//
//  ModelRealm.swift
//  Dog breeds
//
//  Created by Александр Осипов on 03.08.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import Foundation
import RealmSwift

class BreedRealm: Object {
    @objc dynamic var breed: String = ""
    var image = List<BreedImageRealm>()
    
    override static func primaryKey() -> String? {
      return "breed"
    }
}

class BreedImageRealm: Object {
    @objc dynamic var imageURL: String = ""

    override static func primaryKey() -> String? {
      return "imageURL"
    }
}
