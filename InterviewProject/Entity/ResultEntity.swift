//
//  PagingResult.swift
//  InterviewProject
//
//  Created by Mateusz Nogaj on 19/05/2019.
//  Copyright © 2019 Interview. All rights reserved.
//

import Foundation

protocol PagingResult: Codable {
    var count: Int { get }
    var offset: Int { get }
}
