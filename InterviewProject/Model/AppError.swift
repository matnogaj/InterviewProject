//
//  AppError.swift
//  InterviewProject
//
//  Created by Mateusz Nogaj on 20/05/2019.
//  Copyright © 2019 Interview. All rights reserved.
//

import Foundation

class AppError: Error {
    let message: String

    init(_ message: String) {
        self.message = message
    }
}

extension AppError: CustomStringConvertible {
    var description: String {
        return "[AppError] \(message)"
    }
}
