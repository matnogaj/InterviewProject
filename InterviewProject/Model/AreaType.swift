//
//  AreaType.swift
//  InterviewProject
//
//  Created by Mateusz Nogaj on 18/05/2019.
//  Copyright © 2019 Interview. All rights reserved.
//

import Foundation

enum AreaType: String {
    // Country is used for areas included (or previously included) in ISO 3166-1, e.g. United States.
    case country

    // Subdivision is used for the main administrative divisions of a country, e.g. California, Ontario, Okinawa.
    // These are considered when displaying the parent areas for a given area.
    case subdivision

    // County is used for smaller administrative divisions of a country which are not the main administrative divisions
    // but are also not municipalities, e.g. counties in the USA. These are not considered when displaying
    // the parent areas for a given area.
    case county

    // Municipality is used for small administrative divisions which, for urban municipalities, often contain
    // a single city and a few surrounding villages. Rural municipalities typically group several villages together.
    case municipality

    case city // City is used for settlements of any size, including towns and villages.

    // District is used for a division of a large city, e.g. Queens.
    case district

    // Island is used for islands and atolls which don't form subdivisions of their own, e.g. Skye.
    // These are not considered when displaying the parent areas for a given area.
    case island

    case unknown
}

extension String {
    func toAreaType() -> AreaType? {
        return AreaType(rawValue: lowercased())
    }
}
