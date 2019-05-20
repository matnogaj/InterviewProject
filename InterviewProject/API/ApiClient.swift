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

        let task = session.dataTask(with: url) { [weak self] data, response, error in
            guard let strongSelf = self else {
                return
            }

            if let apiError = strongSelf.hasError(response: response) {
                completion(Result(error: apiError))
                return
            }

            if let data = data {
                do {
                    let pagingResult = try JSONDecoder().decode(T.self, from: data)
                    print("Server responded with result count: \(pagingResult.count)")
                    if strongSelf.limit < pagingResult.count { // There's more to download
                        strongSelf.executeMultipleRequests(
                            endpoint: endpoint,
                            offset: strongSelf.limit,
                            count: pagingResult.count,
                            completion: { (remainingPagingResults: Result<[T]>) in
                                if let results = remainingPagingResults.result {
                                    let combined = [pagingResult] + results
                                    completion(Result(result: combined))
                                } else if let error = remainingPagingResults.error {
                                    completion(Result(error: error))
                                }
                        })
                    } else {
                        completion(Result(result: [pagingResult]))
                    }
                } catch let decodeError {
                    completion(Result(error: ApiError("Error while parsing response: \(decodeError)")))
                }
            } else if let error = error {
                completion(Result(error: ApiError("API error: \(error)")))
            }
        }
        task.resume()
    }

    private func executeMultipleRequests<T: PagingResult>(endpoint: Endpoint, offset: Int, count: Int, completion: @escaping (Result<[T]>) -> ()) {
        let remainingPlaces = count - offset
        var requestIndex = 0
        let requestCount = Int(ceilf(Float(remainingPlaces)/Float(limit)))

        var currentOffset = offset
        var resultsArray: [T] = []
        var hasFailed = false
        while(currentOffset < count) {
            guard let url = createUrlRequest(for: endpoint, limit: limit, offset: currentOffset) else {
                completion(Result(error: ApiError("Failed to create url")))
                return
            }

            let task = session.dataTask(with: url) { [weak self] data, response, error in
                guard !hasFailed else {
                    // One of previous requests has already failed, no need to continue
                    return
                }
                requestIndex += 1

                if let apiError = self?.hasError(response: response) {
                    hasFailed = true
                    completion(Result(error: apiError))
                    return
                }

                if let data = data {
                    do {
                        let result = try JSONDecoder().decode(T.self, from: data)
                        resultsArray.append(result)

                        if requestIndex == requestCount {
                            completion(Result(result: resultsArray))
                        }
                    } catch let decodeError {
                        hasFailed = true
                        completion(Result(error: ApiError("Failed to decode reponse data: \(decodeError)")))
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

    private func hasError(response: URLResponse?) -> ApiError? {
        guard let httpResponse = response as? HTTPURLResponse else {
            return nil
        }

        if (200...299).contains(httpResponse.statusCode) {
            return nil
        } else {
            return ApiError("Request failed with HTTP \(httpResponse.statusCode)")
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
