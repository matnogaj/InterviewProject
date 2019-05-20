//
//  Result.swift
//  InterviewProject
//
//  Created by Mateusz Nogaj on 20/05/2019.
//  Copyright © 2019 Interview. All rights reserved.
//

import Foundation

class Result<T> {
    let result: T?
    let error: Error?

    var hasSucceeded: Bool {
        return result != nil
    }

    var hasError: Bool {
        return error != nil
    }

    init(result: T) {
        self.result = result
        self.error = nil
    }

    init(error: Error) {
        self.error = error
        self.result = nil
    }
}
