//
//  BaseAssembly.swift
//  InterviewProject
//
//  Created by Mateusz Nogaj on 19/05/2019.
//  Copyright © 2019 Interview. All rights reserved.
//

import Foundation

class BaseAssembly {
    private var array: [Any] = []

    func register<T>(_ object: T) {
        array.append(object)
    }

    func resolve<T>() -> T {
        let aa = array.first { $0 is T } as? T
        guard let tmp = aa else {
            preconditionFailure("Missing")
        }
        return tmp
    }
}
