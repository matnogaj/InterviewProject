//
//  Area.swift
//  InterviewProject
//
//  Created by Mateusz Nogaj on 18/05/2019.
//  Copyright © 2019 Interview. All rights reserved.
//

import Foundation

struct Area {
    let id: String
    let type: AreaType
    let typeId: String
    let name: String
    let sortName: String
    let lifeSpan: LifeSpan
}

extension AreaEntity {
    func toArea() -> Area {
        return Area(id: id,
                    type: type.toAreaType() ?? .unknown,
                    typeId: typeId,
                    name: name,
                    sortName: sortName,
                    lifeSpan: lifeSpan.toLifeSpan()
        )
    }
}
