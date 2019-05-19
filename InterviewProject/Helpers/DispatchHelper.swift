//
//  DispatchHelper.swift
//  InterviewProject
//
//  Created by Mateusz Nogaj on 19/05/2019.
//  Copyright © 2019 Interview. All rights reserved.
//

import Foundation

func runOnUiThread(_ block: @escaping () -> ()) {
    DispatchQueue.main.async {
        block()
    }
}
