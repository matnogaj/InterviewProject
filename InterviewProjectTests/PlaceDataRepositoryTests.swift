//
//  PlaceDataRepositoryTests.swift
//  InterviewProjectTests
//
//  Created by Mateusz Nogaj on 21/05/2019.
//  Copyright © 2019 Interview. All rights reserved.
//

import XCTest
@testable import InterviewProject

class PlaceDataRepositoryTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSuccess() {
        let repository = PlaceDataRepository(apiClient: MockApiClient())
        repository.searchPlaces(query: "place") { placesResult in
            XCTAssertFalse(placesResult.hasError, "Should not receive errorU")
            XCTAssertTrue(placesResult.hasSucceeded, "Should succeed")
            XCTAssertTrue(placesResult.result?.count == 1, "Wrong number of results: \(placesResult.result?.count ?? 0)")

            guard let place = placesResult.result?.first else {
                XCTFail("Failed to retrieve place")
                return
            }

            XCTAssertTrue("123" == place.id, "Wrong place id: \(place.id)")

            XCTAssertTrue(place.type == .indoorArena, "Type should not be \(place.type?.rawValue ?? "null")")
            XCTAssertTrue(place.typeId == "333", "Type id should not be \(place.typeId ?? "null")")

            XCTAssertTrue(123 == place.score, "Wrong score: \(place.score)")

            XCTAssertTrue(place.name == "name", "Name should not be \(place.name)")

            XCTAssertNil(place.area, "Area should be nil")

            XCTAssertNil(place.coordinates, "Coordinates should be nil")
        }
    }

    func testError() {
        let repository = PlaceDataRepository(apiClient: MockErrorApiClient())
        repository.searchPlaces(query: "place") { result in
            XCTAssertTrue(result.hasError, "Should receive error")
            XCTAssertFalse(result.hasSucceeded, "Should fail")
        }
    }

    private class MockApiClient: IApiClient {
        func executeRequest<T>(endpoint: Endpoint, completion: @escaping (Result<[T]>) -> ()) where T : PagingResult {
            switch endpoint {
            case .searchPlaces(let query):
                XCTAssertTrue(query == "place", "Wrong query: \(query)")
                let placesPagingResult = PlacesPagingResult(
                    count: 37,
                    offset: 11,
                    places: [PlaceEntity(
                        id: "123",
                        type: "Indoor Arena",
                        typeId: "333",
                        score: 123,
                        name: "name",
                        coordinates: nil,
                        area: nil,
                        lifeSpan: LifeSpanEntity(begin: nil, ended: nil)
                        )]
                )
                guard let pagingResult = placesPagingResult as? T else {
                    XCTFail("Failed to cast")
                    return
                }

                completion(Result(result: [pagingResult]))
            }
        }
    }

    private class MockErrorApiClient: IApiClient {
        func executeRequest<T>(endpoint: Endpoint, completion: @escaping (Result<[T]>) -> ()) where T : PagingResult {
            switch endpoint {
            case .searchPlaces(let query):
                XCTAssertTrue(query == "place", "Wrong query: \(query)")
                completion(Result(error: ApiError("error")))
            }
        }
    }
}
