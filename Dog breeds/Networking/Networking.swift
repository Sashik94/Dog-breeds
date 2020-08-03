//
//  Networking.swift
//  Dog breeds
//
//  Created by Александр Осипов on 01.08.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import Foundation

enum FetchType<T: Decodable> {
    case success(result: T)
    case failure(error: String)
}


class Networking {
    
    var urlString = ""
    
    private func request(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            completion(.success(data))
        }.resume()
    }
    
    func fetchTracks<T: Codable>(type: Endpoint, response: @escaping (T?, Error?) -> Void) {
        
        switch type {
        case .breed:
            urlString = Endpoint.breed.absoluteURL?.absoluteString ?? ""
        case .imageBreed(let breed):
            urlString = Endpoint.imageBreed(breed).absoluteURL?.absoluteString ?? ""
        }
        
        request(urlString: urlString) { (result) in
            switch result {
            case .success(let data):
                    do {
                        let tracks = try JSONDecoder().decode(T.self, from: data)
                        response(tracks, nil)
                    } catch let jsonError {
                        print("Failed to decode JSON", jsonError)
                        response(nil, jsonError)
                    }
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil, error)
            }
        }
    }
}
