//
//  TestScheduler.swift
//  InterviewProjectTests
//
//  Created by Mateusz Nogaj on 21/05/2019.
//  Copyright © 2019 Interview. All rights reserved.
//

import Foundation
@testable import InterviewProject

class TestScheduler: IScheduler {
    func runOnUiThread(_ block: @escaping () -> ()) {
        block()
    }
}
