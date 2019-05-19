//
//  ResultEntity.swift
//  InterviewProject
//
//  Created by Mateusz Nogaj on 19/05/2019.
//  Copyright © 2019 Interview. All rights reserved.
//

import Foundation

// FIXME change name since it has to be a protocol
protocol ResultEntity: Codable {
    var count: Int { get }
    var offset: Int { get }
}
