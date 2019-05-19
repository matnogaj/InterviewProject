//
//  AreaEntity.swift
//  InterviewProject
//
//  Created by Mateusz Nogaj on 18/05/2019.
//  Copyright © 2019 Interview. All rights reserved.
//

import Foundation

struct AreaEntity: Codable {
    let id: String
    let type: String
    let typeId: String
    let name: String
    let sortName: String
    let lifeSpan: LifeSpanEntity

    enum CodingKeys: String, CodingKey
    {
        case id
        case type
        case typeId = "type-id"
        case name
        case sortName = "sort-name"
        case lifeSpan = "life-span"
    }
}
