//
//  Place.swift
//  InterviewProject
//
//  Created by Mateusz Nogaj on 18/05/2019.
//  Copyright © 2019 Interview. All rights reserved.
//

import Foundation

struct Place {
    let id: String
    let type: PlaceType?
    let typeId: String?
    let score: Int
    let name: String
    let coordinates: Coordinates?
    let area: Area?
    let lifeSpan: LifeSpan
}

extension PlaceEntity {
    func toPlace() -> Place {
        return Place(id: id,
                     type: type?.toPlaceType(),
                     typeId: typeId,
                     score: score,
                     name: name,
                     coordinates: coordinates?.toCoordinates(),
                     area: area?.toArea(),
                     lifeSpan: lifeSpan.toLifeSpan()
        )
    }
}
