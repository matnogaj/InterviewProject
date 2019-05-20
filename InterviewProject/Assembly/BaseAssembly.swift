//
//  BaseAssembly.swift
//  InterviewProject
//
//  Created by Mateusz Nogaj on 19/05/2019.
//  Copyright © 2019 Interview. All rights reserved.
//

import Foundation

protocol IAssembly {
    func register<T>(_ object: T)
    func resolve<T>() -> T
}

class BaseAssembly: IAssembly {
    private var assembly: [Any] = []

    func register<T>(_ object: T) {
        assembly.append(object)
    }

    func resolve<T>() -> T {
        let object = assembly.first { $0 is T } as? T
        guard let result = object else {
            preconditionFailure("Couldn't find item of type \(T.self) in assembly")
        }
        return result
    }
}
