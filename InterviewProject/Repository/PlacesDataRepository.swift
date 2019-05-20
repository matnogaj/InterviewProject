//
//  PlaceDataRepository.swift
//  InterviewProject
//
//  Created by Mateusz Nogaj on 18/05/2019.
//  Copyright © 2019 Interview. All rights reserved.
//

import Foundation

protocol PlacesRepository {
    func searchPlaces(query: String, response: @escaping (Result<[Place]>) -> ())
}

class PlaceDataRepository: PlacesRepository {
    private let apiClient: IApiClient

    init(apiClient: IApiClient) {
        self.apiClient = apiClient
    }

    func searchPlaces(query: String, response: @escaping (Result<[Place]>) -> ()) {
        apiClient.executeRequest(
            endpoint: .searchPlaces(query: query),
            completion: { (placesResult: Result<[PlacesPagingResult]>) in
                if let placesResult = placesResult.result {
                    let sortedResult = placesResult.sorted(by: { (left, right) -> Bool in
                        left.offset < right.offset
                    })

                    let places = sortedResult.flatMap { $0.places }.map { $0.toPlace() }

                    print("Received places from server: \(places.count)")

                    response(Result(result: places))
                } else if let error = placesResult.error {
                    response(Result(error: error))
                } else {
                    response(Result(error: AppError("Unspecified result")))
                }
        })
    }

}
