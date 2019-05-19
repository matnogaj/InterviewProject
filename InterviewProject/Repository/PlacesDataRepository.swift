//
//  PlaceDataRepository.swift
//  InterviewProject
//
//  Created by Mateusz Nogaj on 18/05/2019.
//  Copyright © 2019 Interview. All rights reserved.
//

import Foundation

protocol PlacesRepository {
    func searchPlaces(query: String, response: @escaping ([Place]) -> ())
}

class PlaceDataRepository: PlacesRepository {
    private let apiClient: IApiClient
    private let limit: Int
    
    init(apiClient: IApiClient, limit: Int = 10) {
        self.apiClient = apiClient
        self.limit = limit
    }

    func searchPlaces(query: String, response: @escaping ([Place]) -> ()) {
        apiClient.executeRequest(
            endpoint: .searchPlaces(query: query, limit: limit, offset: 0),
            completion: { (result: PlacesResultEntity) in // FIXME weak self
                if result.count > self.limit {
//                    self.apiClient.executeRequest(endpoint: .searchPlaces(query: query, limit: self.limit, offset: self.limit), completion: { (result: PlacesResultEntity) in
//                        
//                    })
                } else {
                    let places = result.places.map { $0.toPlace() }
                    response(places)
                }
        })
    }

}
