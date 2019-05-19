//
//  RepositoryAssembly.swift
//  InterviewProject
//
//  Created by Mateusz Nogaj on 18/05/2019.
//  Copyright © 2019 Interview. All rights reserved.
//

import Foundation

class RepositoryAssembly: BaseAssembly {
    static let shared: RepositoryAssembly = {
        return RepositoryAssembly()
    }()
}
