//
//  NetworkClient.swift
//  UnitTesting
//
//  Created by Maksim Vialykh on 7/17/21.
//

import Foundation

protocol NetworkClient {
    func send(request: URLRequest, result: @escaping (Result<Data, Error>) -> Void)
}

enum NetworkError: Error {
    case noData
}

class DefaultNetworkClient: NetworkClient {
    
    func send(request: URLRequest, result: @escaping (Result<Data, Error>) -> Void) {
        var request = request
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let data = data else {
                result(.failure(NetworkError.noData))
                return
            }
            result(.success(data))
        }.resume()
    }
    
}
