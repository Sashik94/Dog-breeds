//
//  Model.swift
//  Dog breeds
//
//  Created by Александр Осипов on 01.08.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import Foundation

struct Breed: Codable {
    let status: String
    let message: [String: [String]]
}

struct Image: Codable {
    let status: String
    let message: [String]
}
