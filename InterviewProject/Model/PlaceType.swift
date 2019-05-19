//
//  PlaceType.swift
//  InterviewProject
//
//  Created by Mateusz Nogaj on 18/05/2019.
//  Copyright © 2019 Interview. All rights reserved.
//

import Foundation

enum PlaceType: String {
    // A place designed for non-live production of music, typically a recording studio.
    case studio

    // A place that has live artistic performances as one of its primary functions, such as a concert hall.
    case venue

    // A place whose main purpose is to host outdoor sport events, typically consisting of a pitch surrounded
    // by a structure for spectators with no roof, or a roof which can be retracted.
    case stadium

    // A place consisting of a large enclosed area with a central event space surrounded by tiered seating for spectators,
    // which can be used for indoor sports, concerts and other entertainment events.
    case indoorArena = "indoor_arena"

    // A place mostly designed and used for religious purposes, like a church, cathedral or synagogue.
    case religiousBuilding = "religious_building"

    // A school, university or other similar educational institution (especially, but not only, one where music is taught)
    case educationalInstitution = "educational_institution"

    // A place (generally a factory) at which physical media are manufactured.
    case pressingPlant = "pressing_plant"

    // Anything which does not fit into the above categories.
    case other
}

extension String {
    func toPlaceType() -> PlaceType? {
        let type = replacingOccurrences(of: " ", with: "_").lowercased()
        return PlaceType(rawValue: type)
    }
}
