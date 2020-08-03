//
//  Routing.swift
//  Dog breeds
//
//  Created by Александр Осипов on 01.08.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import Foundation

protocol PresentBreedProtocol {
    func presentBreed(response: FetchType<Breed>)
}

protocol PresentImageProtocol {
    func presentImage(response: FetchType<Image>)
}

class Routing {
    
    var fetcherService = Networking()
    var delegateBreed: PresentBreedProtocol?
    var delegateImage: PresentImageProtocol?
    
    func getBreed (type: Endpoint) {
        fetcherService.fetchTracks(type: type) { [weak self] (Response: Breed?, Error) in
            if let error = Error {
                self?.delegateBreed?.presentBreed(response: .failure(error: error.localizedDescription))
            } else if let response = Response {
                guard let self = self else { return }
                self.delegateBreed?.presentBreed(response: .success(result: response))
            }
        }
    }
    
    func getImage (type: Endpoint) {
        fetcherService.fetchTracks(type: type) { [weak self] (Response: Image?, Error) in
            if let error = Error {
                self?.delegateImage?.presentImage(response: .failure(error: error.localizedDescription))
            } else if let response = Response {
                guard let self = self else { return }
                self.delegateImage?.presentImage(response: .success(result: response))
            }
        }
    }
    
}
