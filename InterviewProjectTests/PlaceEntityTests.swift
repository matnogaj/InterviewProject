//
//  PlaceEntityTests.swift
//  InterviewProjectTests
//
//  Created by Mateusz Nogaj on 20/05/2019.
//  Copyright © 2019 Interview. All rights reserved.
//

import XCTest
@testable import InterviewProject

class PlaceEntityTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testParsingFromJson() {
        guard let jsonData = try? loadJsonFrom(file: "PlaceEntity") else {
            XCTFail("Failed to load json file")
            return
        }

        guard let placeEntity = try? JSONDecoder().decode(PlaceEntity.self, from: jsonData) else {
            XCTFail("Failed to decode PlaceEntity from json")
            return
        }

        XCTAssertTrue("958d335e-2e17-4b77-9077-335426014817" == placeEntity.id, "Wrong place id: \(placeEntity.id)")

        XCTAssertTrue(placeEntity.type == "Studio", "Type should not be \(placeEntity.type ?? "null")")
        XCTAssertTrue(placeEntity.typeId == "05fa6a09-ff92-3d34-bdbb-5141d3c24f38", "Type id should not be \(placeEntity.typeId ?? "null")")

        XCTAssertTrue(67 == placeEntity.score, "Wrong score: \(placeEntity.score)")

        XCTAssertTrue(placeEntity.name == "Greenhouse Studio", "Name should not be \(placeEntity.name)")

        XCTAssertNotNil(placeEntity.area, "Area should not be nil")

        XCTAssertTrue(placeEntity.area?.id == "f03d09b3-39dc-4083-afd6-159e3f0d462f", "Area id should not be \(placeEntity.area?.id ?? "null")")
        XCTAssertTrue(placeEntity.area?.type == "City", "Area type should not be \(placeEntity.area?.type ?? "null")")
        XCTAssertTrue(placeEntity.area?.typeId == "6fd8f29a-3d0a-32fc-980d-ea697b69da78", "Area type id should not be \(placeEntity.area?.typeId ?? "null")")
        XCTAssertTrue(placeEntity.area?.name == "London", "Area name should not be \(placeEntity.area?.name ?? "null")")
        XCTAssertTrue(placeEntity.area?.sortName == "London", "Area sort name should not be \(placeEntity.area?.sortName ?? "null")")

        XCTAssertNotNil(placeEntity.coordinates, "Coordinates should not be nil")

        XCTAssertTrue("36.0695" == placeEntity.coordinates?.latitude, "Wrong latitude: \(placeEntity.coordinates?.latitude ?? "null")")
        XCTAssertTrue("-79.8114" == placeEntity.coordinates?.longitude, "Wrong longitude: \(placeEntity.coordinates?.longitude ?? "null")")

        XCTAssertTrue(placeEntity.lifeSpan.begin == "1999", "Begin should not be \(placeEntity.lifeSpan.begin ?? "null")")

        XCTAssertTrue(placeEntity.lifeSpan.ended == true, "Ended should not be \(placeEntity.lifeSpan.ended ?? false)")
    }
}
