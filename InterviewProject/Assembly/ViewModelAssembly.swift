//
//  ViewModelAssembly.swift
//  InterviewProject
//
//  Created by Mateusz Nogaj on 19/05/2019.
//  Copyright © 2019 Interview. All rights reserved.
//

import Foundation

class ViewModelAssembly: BaseAssembly {
    static let shared: ViewModelAssembly = {
        return ViewModelAssembly()
    }()
}
