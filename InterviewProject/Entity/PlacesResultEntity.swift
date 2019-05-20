//
//  PlacesPagingResult.swift
//  InterviewProject
//
//  Created by Mateusz Nogaj on 18/05/2019.
//  Copyright © 2019 Interview. All rights reserved.
//

import Foundation

struct PlacesPagingResult: PagingResult {
    let count: Int
    let offset: Int
    let places: [PlaceEntity]
}
