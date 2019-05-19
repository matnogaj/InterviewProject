//
//  ApiClient.swift
//  InterviewProject
//
//  Created by Mateusz Nogaj on 18/05/2019.
//  Copyright © 2019 Interview. All rights reserved.
//

import Foundation

enum Endpoint {
    case searchPlaces(query: String)
}

protocol IApiClient {
    func executeRequest<T: ResultEntity>(endpoint: Endpoint, completion: @escaping (T) -> ())
    func executeRequest<T: ResultEntity>(endpoint: Endpoint, offset: Int, count: Int, completion: @escaping ([T]) -> ())
}

class ApiClient: IApiClient {
    private let scheme: String
    private let host: String
    private let limit = 20

    init(scheme: String = "https", host: String = "musicbrainz.org") {
        self.scheme = scheme
        self.host = host
    }

    private let session = URLSession(configuration: URLSessionConfiguration.default)

    private func createUrl(endpoint: Endpoint, limit: Int, offset: Int) -> URLRequest {
        guard limit > 0 else {
            preconditionFailure("Limit should not be negative")
        }
        guard offset >= 0 else {
            preconditionFailure("Offset should not be negative")
        }

        var components = URLComponents()
        components.scheme = scheme
        components.host = host

        var queryItems: [URLQueryItem] = []
        var method: String?

        switch endpoint {
        case .searchPlaces(let query):
            components.path = "/ws/2/place"
            queryItems.append(contentsOf: [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "offset", value: "\(offset)")
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

    func executeRequest<T: ResultEntity>(endpoint: Endpoint, completion: @escaping (T) -> ()) {
        let url = createUrl(endpoint: endpoint, limit: limit, offset: 0)

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

    func executeRequest<T: ResultEntity>(endpoint: Endpoint, offset: Int, count: Int, completion: @escaping ([T]) -> ()) {
        let remaining = count - offset

        let requestCount = Int(ceilf(Float(remaining)/Float(limit)))

        var off = offset
        var indexFinished = 0
        var fullArray: [T] = []
        while(off < count) {
            let url = createUrl(endpoint: endpoint, limit: limit, offset: off)

            let xxx = off
            let task = session.dataTask(with: url) {
                data, response, error in

                indexFinished += 1
                print("Index of finised: \(indexFinished) / \(requestCount)")
                print("Current offset: \(xxx); count: \(count)")

                if let data = data {
                    if let result = try? JSONDecoder().decode(T.self, from: data) {
                        fullArray.append(result)

                        if indexFinished == requestCount {
                            print("Last request")

                            completion(fullArray)
                        }

                    } else {
                        print("Some error")
                        // FIXME add error handling
                    }
                }
            }
            off += limit

            task.resume()
        }
    }
}
