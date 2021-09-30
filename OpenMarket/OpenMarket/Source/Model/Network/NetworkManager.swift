//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/25.
//

import Foundation

protocol NetworkManagable {
    func request(with urlString: String, with item: Any, httpMethod: HttpMethod, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask?
    func fetch(with urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask?
}

final class NetworkManager: NetworkManagable {
    private let urlSession: URLSession
    private let requestMaker: RequestMakable

    init(urlSession: URLSession = .shared, requestMaker: RequestMakable = RequestMaker()) {
        self.urlSession = urlSession
        self.requestMaker = requestMaker
    }

    private func retrieveData(with request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        let task = urlSession.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(.connectionProblem))
                return
            }

            if let response = response as? HTTPURLResponse,
                  OpenMarketAPI.successStatusCode.contains(response.statusCode) == false {
                completion(.failure(.invalidResponseStatuscode(response.statusCode)))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            completion(.success(data))
        }
        task.resume()
        return task
    }

    func request(with urlString: String, with item: Any, httpMethod: HttpMethod, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return nil
        }
        guard let request = requestMaker.request(url: url, httpMethod: httpMethod, with: item) else {
            completion(.failure(.invalidRequest))
            return nil
        }
        return retrieveData(with: request, completion: completion)
    }

    func fetch(with urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return nil
        }
        let urlRequest = URLRequest(url: url)
        return retrieveData(with: urlRequest, completion: completion)
    }
}
