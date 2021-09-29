//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/09/25.
//

import Foundation

protocol NetworkManagable {
    func request(url: URL, with item: Any, httpMethod: HttpMethod, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask?
    func fetch(url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask?
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
        }
        task.resume()
        return task
    }

    func request(url: URL, with item: Any, httpMethod: HttpMethod, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        guard let request = requestMaker.request(url: url, httpMethod: httpMethod, with: item) else {
            completion(.failure(.invalidRequest))
            return nil
        }
        return retrieveData(with: request, completion: completion)
    }

    func fetch(url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        let urlRequest = URLRequest(url: url)
        return retrieveData(with: urlRequest, completion: completion)
    }
}
