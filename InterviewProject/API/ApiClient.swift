//
//  ApiClient.swift
//  InterviewProject
//
//  Created by Mateusz Nogaj on 18/05/2019.
//  Copyright © 2019 Interview. All rights reserved.
//

import Foundation

enum Endpoint {
    case searchPlaces(query: String, limit: Int, offset: Int)
}

protocol IApiClient {
    func executeRequest<T: Decodable>(endpoint: Endpoint, completion: @escaping (T) -> ())
}

class ApiClient: IApiClient {
    private let scheme: String
    private let host: String

    init(scheme: String = "https", host: String = "musicbrainz.org") {
        self.scheme = scheme
        self.host = host
    }

    private let session = URLSession(configuration: URLSessionConfiguration.background(withIdentifier: "Networking"))

    private func createUrl(endpoint: Endpoint) -> URLRequest {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host

        var queryItems: [URLQueryItem] = []
        var method: String?

        switch endpoint {
        case .searchPlaces(let query, let limit, let offset):
            components.path = "/ws/2/place"
            queryItems.append(contentsOf: [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "limit", value: limit.description),
                URLQueryItem(name: "offset", value: offset.description)
                ])
            method = "GET"
        }

        queryItems.append(URLQueryItem(name: "fmt", value: "json"))

        components.queryItems = queryItems

        guard let url = components.url else {
            preconditionFailure("Couldn't create url")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        return urlRequest
    }

    func executeRequest<T: Decodable>(endpoint: Endpoint, completion: @escaping (T) -> ()) {
        let url = createUrl(endpoint: endpoint)

        let task = session.dataTask(with: url) {
            data, response, error in

            if let data = data {
                if let result = try? JSONDecoder().decode(T.self, from: data) {
                    completion(result)
                } else {
                    // FIXME add error handling
                }
            }
        }
        task.resume()
    }
}
