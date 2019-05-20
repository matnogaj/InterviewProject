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
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

    private var displayedPlaces: [Place : MKAnnotation] = [:]

    lazy var viewModel: SearchViewModel = ViewModelAssembly.shared.resolve()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        searchTextField?.delegate = self
        activityIndicatorView.stopAnimating()

        bindToViewModel()
    }

    private func clearAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        displayedPlaces = [:]
    }

    private func bindToViewModel() {
        viewModel.onUpdate = { [weak self] places in
            print("onUpdate: \(places.count)")
            guard let strongSelf = self else {
                return
            }

            let toBeAdded = places.filter { place in
                return !strongSelf.displayedPlaces.keys.contains(place)
            }

            let toBeRemoved = strongSelf.displayedPlaces.keys.filter { place in
                return !places.contains(place)
            }

            toBeAdded.forEach { place in
                if let lat = place.coordinates?.latitude, let lon = place.coordinates?.longitude {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    annotation.title = place.name
                    annotation.subtitle = place.area?.name
                    strongSelf.displayedPlaces[place] = annotation
                    strongSelf.mapView.addAnnotation(annotation)
                }
            }

            toBeRemoved.forEach { place in
                if let annotation = strongSelf.displayedPlaces.removeValue(forKey: place) {
                    strongSelf.mapView.removeAnnotation(annotation)
                }
            }
        }

        viewModel.onProgress = { [weak self] progress in
            if progress {
                self?.activityIndicatorView.startAnimating()
            } else {
                self?.activityIndicatorView.stopAnimating()
            }
        }

        viewModel.onError = { [weak self] error in
            print("Received error: \(error)")
        }
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        viewModel.search(text: textField.text ?? "")
        
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        viewModel.clear()
        return true
    }
}
