//
//  SearchViewController.swift
//  InterviewProject
//
//  Created by Mateusz Nogaj on 18/05/2019.
//  Copyright © 2019 Interview. All rights reserved.
//

import UIKit
import MapKit

class SearchViewController: UIViewController {
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var mapView: MKMapView!

    private var displayedPlaces: [Place : MKAnnotation] = [:]

    lazy var viewModel: SearchViewModel = ViewModelAssembly.shared.resolve()!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        searchTextField?.delegate = self

        viewModel.onUpdate = { places in
            let toBeAdded = places.filter { place in
                return !self.displayedPlaces.keys.contains(place)
            }

            let toBeRemoved = self.displayedPlaces.keys.filter { place in
                return !places.contains(place)
            }

            toBeAdded.forEach { place in
                if let lat = place.coordinates?.latitude, let lon = place.coordinates?.longitude {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    annotation.title = place.name
                    annotation.subtitle = place.area?.name
                    self.displayedPlaces[place] = annotation
                    self.mapView.addAnnotation(annotation)
                }
            }

            toBeRemoved.forEach { place in
                if let annotation = self.displayedPlaces.removeValue(forKey: place) {
                    self.mapView.removeAnnotation(annotation)
                }
            }
        }
    }

    private func clearAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        displayedPlaces = [:]

    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        clearAnnotations()

        viewModel.search(text: textField.text ?? "")
        
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // Clear all annotations
        clearAnnotations()
        return true
    }
}
