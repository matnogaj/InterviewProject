//
//  Scheduler.swift
//  InterviewProject
//
//  Created by Mateusz Nogaj on 21/05/2019.
//  Copyright © 2019 Interview. All rights reserved.
//

import Foundation

protocol IScheduler {
    func runOnUiThread(_ block: @escaping () -> ())
}

class Scheduler: IScheduler {
    func runOnUiThread(_ block: @escaping () -> ()) {
        DispatchQueue.main.async {
            block()
        }
    }
}
