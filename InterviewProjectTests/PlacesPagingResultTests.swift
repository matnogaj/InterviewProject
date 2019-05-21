//
//  PlacesPagingResultTests.swift
//  InterviewProjectTests
//
//  Created by Mateusz Nogaj on 20/05/2019.
//  Copyright © 2019 Interview. All rights reserved.
//

import XCTest
@testable import InterviewProject

class PlacesPagingResultTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testParsingFromJson() {
        guard let jsonData = try? loadJsonFrom(file: "PlacesPagingResult") else {
            XCTFail("Failed to load file")
            return
        }

        guard let placesPagingResult = try? JSONDecoder().decode(PlacesPagingResult.self, from: jsonData) else {
            XCTFail("Failed to decode PlacesPagingResult from json")
            return
        }

        XCTAssertTrue(128 == placesPagingResult.count, "Wrong count: \(placesPagingResult.count)")
        XCTAssertTrue(60 == placesPagingResult.offset, "Wrong offset: \(placesPagingResult.offset)")
        XCTAssertTrue(20 == placesPagingResult.places.count, "Wrong places count: \(placesPagingResult.places.count)")
    }
}
