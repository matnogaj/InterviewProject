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
    func executeRequest<T: PagingResult>(endpoint: Endpoint, completion: @escaping (Result<[T]>) -> ())
}

class ApiClient: IApiClient {
    private struct Consts {
        static let queryKey = "query"
        static let limitKey = "limit"
        static let offsetKey = "offset"
        static let formatKey = "fmt"

        static let placeEndpoint = "/ws/2/place"
    }

    private let scheme: String
    private let host: String
    private let limit = 20
    private let session = URLSession(configuration: URLSessionConfiguration.default)

    init(scheme: String = "https", host: String = "musicbrainz.org") {
        self.scheme = scheme
        self.host = host
    }

    func executeRequest<T: PagingResult>(endpoint: Endpoint, completion: @escaping (Result<[T]>) -> ()) {
        guard let url = createUrlRequest(for: endpoint, limit: limit, offset: 0) else {
            completion(Result(error: ApiError("Failed to create url")))
            return
        }

        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                if let result = try? JSONDecoder().decode(T.self, from: data) {
                    if self.limit < result.count { // There's more to download
                        self.executeMultipleRequests(endpoint: endpoint, offset: self.limit, count: result.count, completion: { (rrr: Result<[T]>) in
                            let tmp = [result] + (rrr.result ?? [])
                            completion(Result(result: tmp))
                        })
                    } else {
                        completion(Result(result: [result]))
                    }
                } else {
                    completion(Result(error: ApiError("Error while parsing response")))
                }
            } else if let error = error {
                completion(Result(error: ApiError("API error: \(error)")))
            }
        }
        task.resume()
    }

    private func executeMultipleRequests<T: PagingResult>(endpoint: Endpoint, offset: Int, count: Int, completion: @escaping (Result<[T]>) -> ()) {
        let remaining = count - offset
        let requestCount = Int(ceilf(Float(remaining)/Float(limit)))

        var currentOffset = offset
        var requestIndex = 0
        var fullArray: [T] = []
        var hasFailed = false
        while(currentOffset < count) {
            guard let url = createUrlRequest(for: endpoint, limit: limit, offset: currentOffset) else {
                completion(Result(error: ApiError("Failed to create url")))
                return
            }

            let task = session.dataTask(with: url) { data, response, error in
                guard !hasFailed else {
                    // One of previous requests has already failed, no need to continue
                    return
                }
                requestIndex += 1

                if let data = data {
                    if let result = try? JSONDecoder().decode(T.self, from: data) {
                        fullArray.append(result)

                        if requestIndex == requestCount {
                            completion(Result(result: fullArray))
                        }

                    } else {
                        hasFailed = true
                        completion(Result(error: ApiError("Failed to decode reponse data")))
                    }
                } else if let error = error {
                    hasFailed = true
                    completion(Result(error: ApiError("API error: \(error)")))
                }
            }
            currentOffset += limit

            task.resume()
        }
    }

    private func createUrlRequest(for endpoint: Endpoint, limit: Int, offset: Int) -> URLRequest? {
        guard limit >= 0 else {
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
            components.path = Consts.placeEndpoint
            queryItems.append(contentsOf: [
                URLQueryItem(name: Consts.queryKey, value: query),
                URLQueryItem(name: Consts.limitKey, value: "\(limit)"),
                URLQueryItem(name: Consts.offsetKey, value: "\(offset)")
                ])
            method = "GET"
        }

        queryItems.append(URLQueryItem(name: Consts.formatKey, value: "json"))

        components.queryItems = queryItems

        guard let url = components.url else {
            return nil
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        return urlRequest
    }
}
