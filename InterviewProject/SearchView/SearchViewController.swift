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

    lazy var viewModel: SearchViewModel = ViewModelAssembly.shared.resolve()!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        searchTextField?.delegate = self
    }    
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        viewModel.search(text: textField.text ?? "") { result in
            print("Received filtered places: \(result.count)")

            result.forEach({ place in
                if let year = place.lifeSpan.year {
                    // TODO add displaying on a map
                }
            })
        }

        return true
    }
}

