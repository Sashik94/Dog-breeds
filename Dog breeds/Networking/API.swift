//
//  API.swift
//  Dog breeds
//
//  Created by Александр Осипов on 01.08.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import Foundation

enum Endpoint {
    case breed
    case imageBreed(_ breed: String)
    
    private var baseURL: URL { URL(string: "https://dog.ceo/api/")! }
    
    private func path() -> String {
        switch self {
        case .breed:
            return "breeds/list/all"
        case .imageBreed:
            return "breed"
        }
    }
    
    var absoluteURL: URL? {
        var URL = baseURL.appendingPathComponent(self.path())
        switch self {
        case .breed: break
        case .imageBreed(let breed):
            URL.appendPathComponent("/\(breed)/images")
        }
        return URL
    }
}
