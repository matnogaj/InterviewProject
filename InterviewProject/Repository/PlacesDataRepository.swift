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

    init(apiClient: IApiClient) {
        self.apiClient = apiClient
    }

    func searchPlaces(query: String, response: @escaping ([Place]) -> ()) {
        apiClient.executeRequest(
            endpoint: .searchPlaces(query: query),
            completion: { (result: PlacesResultEntity) in // FIXME weak self
                if result.count > 20 {
                    // FIXME move this inside ApiClient
                    self.apiClient.executeRequest(endpoint: .searchPlaces(query: query), offset: 20, count: result.count, completion: { (result: [PlacesResultEntity]) in
                        print("Received remaining places: \(result.count) separate results")
                    })
                } else {
                    let places = result.places.map { $0.toPlace() }
                    response(places)
                }
        })
    }

}
