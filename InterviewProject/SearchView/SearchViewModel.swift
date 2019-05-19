//
//  SearchViewModel.swift
//  InterviewProject
//
//  Created by Mateusz Nogaj on 19/05/2019.
//  Copyright © 2019 Interview. All rights reserved.
//

import Foundation

class SearchViewModel {
    init(repository: PlacesRepository = RepositoryAssembly.shared.resolve()) {
        self.repository = repository
    }

    private let referenceYear = 1990

    private let repository: PlacesRepository

    private var placesRefreshTimer: Timer?

    var onUpdate: (([Place])->()) = { _ in }
    var onError: ((Error)->()) = { _ in }
    var onProgress: ((Bool)->()) = { _ in }

    func search(text: String) {
        onProgress(true)

        repository.searchPlaces(query: text, response: { (places: [Place]) in
            print("Received places: \(places.count)")

            let initialPlacesToShow = places.filter { place in
                if let year = place.lifeSpan.year {
                    return year > self.referenceYear
                }
                return false
            }

            runOnUiThread {
                self.onProgress(false)
                self.onUpdate(initialPlacesToShow)

                let startTime = Date.timeIntervalSinceReferenceDate
                self.placesRefreshTimer?.invalidate()
                self.placesRefreshTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
                    let secondsDiff = Date.timeIntervalSinceReferenceDate - startTime
                    print("Timer: \(secondsDiff)")

                    let placesToShow = initialPlacesToShow.filter { place in
                        if let year = place.lifeSpan.year {
                            return Double(year - self.referenceYear) > secondsDiff
                        }
                        return false
                    }

                    self.onUpdate(placesToShow)

                    if placesToShow.isEmpty {
                        timer.invalidate()
                    }
                })
            }
        })
    }
}
