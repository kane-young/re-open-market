//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/25.
//

import Foundation

final class NetworkManager {
    private enum Format {
        static let contentType = "Content-Type"
        static let applicationJson = "application/json"

        static func multiPartContentType(_ boundary: String) -> String {
            return "multipart/form-data; boundary=\(boundary)"
        }
    }

    private let urlSession: URLSession
    private let requestMaker: RequestMakable

    init(urlSession: URLSession = .shared, requestMaker: RequestMakable) {
        self.urlSession = urlSession
        self.requestMaker = requestMaker
    }

    private func retrieveData(with request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        urlSession.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(.connectionProblem))
                return
            }

            guard let response = response as? HTTPURLResponse,
                  OpenMarketAPI.successStatusCode.contains(response.statusCode) else {
                completion(.failure(.invalidResponseStatuscode))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            completion(.success(data))
        }.resume()
    }

    func request(urlString: String, with item: Any, httpMethod: HttpMethod, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url: URL = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        guard let request = requestMaker.request(url: url, httpMethod: httpMethod, with: item) else {
            completion(.failure(.invalidRequest))
            return
        }
        retrieveData(with: request, completion: completion)
    }

    func fetch(urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url: URL = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        let urlRequest = URLRequest(url: url)
        retrieveData(with: urlRequest, completion: completion)
    }
}
