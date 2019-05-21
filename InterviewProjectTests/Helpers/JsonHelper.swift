//
//  JsonHelper.swift
//  InterviewProjectTests
//
//  Created by Mateusz Nogaj on 20/05/2019.
//  Copyright © 2019 Interview. All rights reserved.
//

import Foundation
import XCTest

extension XCTestCase {
    func loadJsonFrom(file: String) throws -> Data? {
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: file, ofType: "json") else {
            return nil
        }
        var content = try? String(contentsOfFile: path)
        content = content?.replacingOccurrences(of: "\n", with: "")
        return content?.data(using: .utf8)
    }
}
