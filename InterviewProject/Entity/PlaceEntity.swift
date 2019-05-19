//
//  Place.swift
//  InterviewProject
//
//  Created by Mateusz Nogaj on 18/05/2019.
//  Copyright © 2019 Interview. All rights reserved.
//

import Foundation

// A place is a building or outdoor area used for performing or producing music.
struct PlaceEntity: Codable {
    let id: String
    let type: String?
    let typeId: String?
    let score: Int
    let name: String
    let coordinates: CoordinatesEntity?
    let area: AreaEntity?
    let lifeSpan: LifeSpanEntity

    enum CodingKeys: String, CodingKey
    {
        case id
        case type
        case typeId = "type-id"
        case score
        case name
        case coordinates
        case area
        case lifeSpan = "life-span"
    }
}
