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

    private let repository: PlacesRepository

    func search(text: String, response: @escaping ([Place]) -> ()) {
        repository.searchPlaces(query: text, response: { (places: [Place]) in
            print("Received places: \(places.count)")
            let filteredPlaces = places.filter { place in
                place.lifeSpan.year ?? 0 > 1990
            }

            runOnUiThread {
                response(filteredPlaces)
            }
        })
    }
}
