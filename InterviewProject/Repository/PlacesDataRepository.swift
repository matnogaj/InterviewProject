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
            completion: { (result: [PlacesResultEntity]) in // FIXME weak self
                let sortedResult = result.sorted(by: { (left, right) -> Bool in
                    left.offset < right.offset
                })

                sortedResult.forEach {
                    print("\($0.offset)")
                }
                let places = sortedResult.flatMap { $0.places }.map { $0.toPlace() }
                response(places)
        })
    }

}
