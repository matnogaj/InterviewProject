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

        activityIndicatorView.isHidden = true

        bindToViewModel()
    }

//    private func clearAnnotations() {
//        mapView.removeAnnotations(mapView.annotations)
//        displayedPlaces = [:]
//    }

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
                if let annotation = place.toAnnotation() {
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
                self?.showActivityIndicator()
            } else {
                self?.hideActivityIndicator()
            }
        }

        viewModel.onError = { error in
            print("Received error: \(error)")
        }
    }

    private func showActivityIndicator() {
        activityIndicatorView.alpha = 0.0
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()

        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.activityIndicatorView.alpha = 1.0
        }
    }

    private func hideActivityIndicator() {
        activityIndicatorView.alpha = 0.0

        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.activityIndicatorView.alpha = 0.0
        }) { [weak self] _ in
            self?.activityIndicatorView.isHidden = true
            self?.activityIndicatorView.stopAnimating()
        }
    }
}

private extension Place {
    func toAnnotation() -> MKAnnotation? {
        if let lat = coordinates?.latitude, let lon = coordinates?.longitude {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            annotation.title = name
            annotation.subtitle = area?.name
            return annotation
        }
        return nil
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        let query = textField.text ?? ""
        print("Search places: '\(query)'")
        viewModel.search(query: query)
        
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        viewModel.clear()
        return true
    }
}
