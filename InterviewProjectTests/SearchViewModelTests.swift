//
//  SearchViewModelTests.swift
//  InterviewProjectTests
//
//  Created by Mateusz Nogaj on 20/05/2019.
//  Copyright © 2019 Interview. All rights reserved.
//

import XCTest
@testable import InterviewProject

class SearchViewModelTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testReceivedPlaces() {
        let searchViewModel = SearchViewModel(repository: MockPlacesRepository(), scheduler: TestScheduler())

        var receivedPlaces = false
        var receivedProgress = false
        var lastProgress = false
        var receivedError = false

        searchViewModel.onUpdate = { places in
            receivedPlaces = (places.count == 3)
        }
        searchViewModel.onProgress = { progress in
            receivedProgress = true
            lastProgress = progress
        }
        searchViewModel.onError = { error in
            receivedError = true
        }

        searchViewModel.search(query: "?")

        XCTAssertTrue(receivedPlaces, "SearchViewModel should execute update block with correct number of places")
        XCTAssertTrue(receivedProgress, "SearchViewModel should execute progress block")
        XCTAssertFalse(lastProgress, "SearchViewModel should execute progress block with false as the last")
        XCTAssertFalse(receivedError, "SearchViewModel should not execute error block")
    }

    func testReceivedDuplicatePlaces() {
        let searchViewModel = SearchViewModel(repository: MockDuplicatePlacesRepository(), scheduler: TestScheduler())

        var receivedPlaces = false
        var receivedProgress = false
        var lastProgress = false
        var receivedError = false

        searchViewModel.onUpdate = { places in
            receivedPlaces = (places.count == 3)
        }
        searchViewModel.onProgress = { progress in
            receivedProgress = true
            lastProgress = progress
        }
        searchViewModel.onError = { error in
            receivedError = true
        }

        searchViewModel.search(query: "?")

        XCTAssertTrue(receivedPlaces, "SearchViewModel should execute update block with correct number of places")
        XCTAssertTrue(receivedProgress, "SearchViewModel should execute progress block")
        XCTAssertFalse(lastProgress, "SearchViewModel should execute progress block with false as the last")
        XCTAssertFalse(receivedError, "SearchViewModel should not execute error block")
    }

    func testReceivedEmptyPlaces() {
        let searchViewModel = SearchViewModel(repository: MockEmptyPlacesRepository(), scheduler: TestScheduler())

        var receivedPlaces = false
        var receivedProgress = false
        var lastProgress = false
        var receivedError = false

        searchViewModel.onUpdate = { places in
            receivedPlaces = places.isEmpty
        }
        searchViewModel.onProgress = { progress in
            receivedProgress = true
            lastProgress = progress
        }
        searchViewModel.onError = { error in
            receivedError = true
        }

        searchViewModel.search(query: "?")

        XCTAssertTrue(receivedPlaces, "SearchViewModel should execute update block with places")
        XCTAssertTrue(receivedProgress, "SearchViewModel should execute progress block")
        XCTAssertFalse(lastProgress, "SearchViewModel should execute progress block with false as the last")
        XCTAssertFalse(receivedError, "SearchViewModel should not execute error block")
    }

    func testReceivedError() {
        let searchViewModel = SearchViewModel(repository: MockErrorPlacesRepository(), scheduler: TestScheduler())

        var receivedPlaces = false
        var receivedProgress = false
        var lastProgress = false
        var receivedError = false
        var correctError = false

        searchViewModel.onUpdate = { places in
            receivedPlaces = places.isEmpty
        }
        searchViewModel.onProgress = { progress in
            receivedProgress = true
            lastProgress = progress
        }
        searchViewModel.onError = { error in
            receivedError = true
            correctError = (error as? AppError)?.message == "Error"
        }

        searchViewModel.search(query: "?")

        XCTAssertTrue(receivedPlaces, "SearchViewModel should execute update block with empty places")
        XCTAssertTrue(receivedProgress, "SearchViewModel should execute progress block")
        XCTAssertFalse(lastProgress, "SearchViewModel should execute progress block with false as the last")
        XCTAssertTrue(receivedError, "SearchViewModel should execute error block")
        XCTAssertTrue(correctError, "SearchViewModel should send a proper error messsage")
    }

    private class MockPlacesRepository: PlacesRepository {
        func searchPlaces(query: String, response: @escaping (Result<[Place]>) -> ()) {
            let places: [Place] = [
                Place(
                    id: "1",
                    type: PlaceType.studio,
                    typeId: "1",
                    score: 100,
                    name: "Some studio",
                    coordinates: nil,
                    area: nil,
                    lifeSpan: LifeSpan(begin: nil, year: 2008, ended: false)
                ),
                Place(
                    id: "2",
                    type: PlaceType.venue,
                    typeId: "2",
                    score: 99,
                    name: "Some venue",
                    coordinates: nil,
                    area: nil,
                    lifeSpan: LifeSpan(begin: nil, year: 2001, ended: false)
                ),
                Place(
                    id: "3",
                    type: PlaceType.indoorArena,
                    typeId: "3",
                    score: 50,
                    name: "Some indoor arena",
                    coordinates: nil,
                    area: nil,
                    lifeSpan: LifeSpan(begin: nil, year: 2015, ended: false)
                ),
                Place(
                    id: "4",
                    type: PlaceType.educationalInstitution,
                    typeId: "4",
                    score: 77,
                    name: "Some educational institution",
                    coordinates: nil,
                    area: nil,
                    lifeSpan: LifeSpan(begin: nil, year: 1950, ended: false)
                ),
                Place(
                    id: "5",
                    type: PlaceType.religiousBuilding,
                    typeId: "5",
                    score: 67,
                    name: "Some indoor arena",
                    coordinates: nil,
                    area: nil,
                    lifeSpan: LifeSpan(begin: nil, year: nil, ended: false)
                )
            ]
            response(Result(result: places))
        }
    }

    private class MockDuplicatePlacesRepository: PlacesRepository {
        func searchPlaces(query: String, response: @escaping (Result<[Place]>) -> ()) {
            let place1 = Place(
                id: "1",
                type: PlaceType.studio,
                typeId: "1",
                score: 100,
                name: "Some studio",
                coordinates: nil,
                area: nil,
                lifeSpan: LifeSpan(begin: nil, year: 2015, ended: false)
            )
            let place2 = Place(
                id: "2",
                type: PlaceType.venue,
                typeId: "2",
                score: 99,
                name: "Some venue",
                coordinates: nil,
                area: nil,
                lifeSpan: LifeSpan(begin: nil, year: 2000, ended: false)
            )
            let place3 = Place(
                id: "3",
                type: PlaceType.indoorArena,
                typeId: "3",
                score: 50,
                name: "Some indoor arena",
                coordinates: nil,
                area: nil,
                lifeSpan: LifeSpan(begin: nil, year: 2008, ended: false)
            )

            let places: [Place] = [
                place1, place1, place1,
                place2, place2,
                place3,
                place1, place2, place3
            ]
            response(Result(result: places))
        }
    }

    private class MockEmptyPlacesRepository: PlacesRepository {
        func searchPlaces(query: String, response: @escaping (Result<[Place]>) -> ()) {
            let empty: [Place] = []
            response(Result(result: empty))
        }
    }

    private class MockErrorPlacesRepository: PlacesRepository {
        func searchPlaces(query: String, response: @escaping (Result<[Place]>) -> ()) {
            response(Result(error: AppError("Error")))
        }
    }
}
