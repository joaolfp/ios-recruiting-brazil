//
//  DetailsService.swift
//  Movs
//
//  Created by Joao Lucas on 19/10/20.
//

import Foundation

class DetailsService: DetailsServiceProtocol {
    
    private let client: HTTPClientProtocol

    init(client: HTTPClientProtocol = HTTPClient()) {
        self.client = client
    }
    
    func getImages(idMovie: Int, completion: @escaping (Result<ImagesDTO, HTTPError>) -> Void) {
        let endpoint: MovsEndpoint = .getImages(id: idMovie)
        let request = endpoint.request
        
        client.request(request, completion: completion)
    }
}
