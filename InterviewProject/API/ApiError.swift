//
//  ApiError.swift
//  InterviewProject
//
//  Created by Mateusz Nogaj on 20/05/2019.
//  Copyright © 2019 Interview. All rights reserved.
//

import Foundation

class ApiError: Error {
    let message: String

    init(_ message: String) {
        self.message = message
    }
}
