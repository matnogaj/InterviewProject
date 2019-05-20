//
//  SearchViewModel.swift
//  InterviewProject
//
//  Created by Mateusz Nogaj on 19/05/2019.
//  Copyright © 2019 Interview. All rights reserved.
//

import Foundation

class SearchViewModel {
    private struct Consts {
        static let referenceYear = 1990
        static let refreshInterval: TimeInterval = 1.0
    }

    private let repository: PlacesRepository
    private var placesRefreshTimer: Timer?

    var onUpdate: (([Place])->()) = { _ in }
    var onError: ((Error)->()) = { _ in }
    var onProgress: ((Bool)->()) = { _ in }

    init(repository: PlacesRepository = RepositoryAssembly.shared.resolve()) {
        self.repository = repository
    }

    func search(text: String) {
        onProgress(true)
        onUpdate([])

        repository.searchPlaces(query: text, response: { [weak self] (placesResult: Result<[Place]>) in
            if let places = placesResult.result {
                let initialPlacesToShow = places.filter { place in
                    if let year = place.lifeSpan.year {
                        return year > Consts.referenceYear
                    }
                    return false
                }

                runOnUiThread { [weak self] in
                    self?.onProgress(false)
                    self?.onUpdate(initialPlacesToShow)
                    self?.startTimer(initialPlacesToShow: initialPlacesToShow)
                }
            } else {
                runOnUiThread { [weak self] in
                    self?.onProgress(false)
                    self?.onError(placesResult.error ?? AppError("Unknown error"))
                }
            }
        })
    }

    func clear() {
        placesRefreshTimer?.invalidate()
        onUpdate([])
    }

    private func startTimer(initialPlacesToShow: [Place]) {
        guard !initialPlacesToShow.isEmpty else {
            return
        }
        let startTime = Date.timeIntervalSinceReferenceDate
        placesRefreshTimer?.invalidate()

        placesRefreshTimer = Timer.scheduledTimer(
            withTimeInterval: Consts.refreshInterval,
            repeats: true,
            block: { [weak self] timer in
            let elapsedSeconds = Date.timeIntervalSinceReferenceDate - startTime

            let placesToShow = initialPlacesToShow.filter { place in
                if let year = place.lifeSpan.year {
                    return Double(year - Consts.referenceYear) > elapsedSeconds
                }
                return false
            }

            self?.onUpdate(placesToShow)

            if placesToShow.isEmpty {
                timer.invalidate()
            }
        })
    }

    deinit {
        placesRefreshTimer?.invalidate()
    }
}
