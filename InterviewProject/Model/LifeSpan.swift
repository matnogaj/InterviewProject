//
//  LifeSpan.swift
//  InterviewProject
//
//  Created by Mateusz Nogaj on 19/05/2019.
//  Copyright © 2019 Interview. All rights reserved.
//

import Foundation

struct LifeSpan {
    let begin: String?
    let year: Int?
    let ended: Bool
}

extension LifeSpanEntity {
    func toLifeSpan() -> LifeSpan {
        var year: Int?
        if let dateString = begin {
            // Manual parsing is more reliable in this case than using DateFormatter.
            if let index = dateString.firstIndex(of: "-") {
                let yearString = dateString[..<index]
                year = Int(yearString)
            } else {
                year = Int(dateString)
            }
        }

        return LifeSpan(begin: begin, year: year, ended: ended ?? false)
    }
}
