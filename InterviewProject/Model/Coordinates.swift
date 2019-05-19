//
//  Coordinates.swift
//  InterviewProject
//
//  Created by Mateusz Nogaj on 19/05/2019.
//  Copyright © 2019 Interview. All rights reserved.
//

import Foundation

struct Coordinates {
    let latitude: Double
    let longitude: Double
}

extension CoordinatesEntity {
    func toCoordinates() -> Coordinates? {
        guard let latitude = Double(self.latitude), let longitude = Double(self.longitude) else {
            return nil
        }
        return Coordinates(latitude: latitude, longitude: longitude)
    }
}
