//
//  NetworkManager.swift
//  RickAndMorty
//
//  Created by Beqa Tabunidze on 27.05.24.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case requestFailed
    case decodingError
    case unknown(errorMessage: String)
}

protocol NetworkManagerProtocol {
    func get<T: Decodable>(endpoint: Endpoint, responseType: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void)
    func get<T: Decodable>(url: URL, responseType: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    func get<T: Decodable>(endpoint: Endpoint, responseType: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.query
        
        guard let url = urlComponents.url else {
            completion(.failure(.badURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.unknown(errorMessage: error.localizedDescription)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed))
                return
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                guard let data = data else {
                    completion(.failure(.decodingError))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode(responseType, from: data)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(.decodingError))
                }
            default:
                completion(.failure(.unknown(errorMessage: "Unknown error")))
            }
        }.resume()
    }
    
    func get<T: Decodable>(url: URL, responseType: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.unknown(errorMessage: error.localizedDescription)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed))
                return
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                guard let data = data else {
                    completion(.failure(.decodingError))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode(responseType, from: data)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(.decodingError))
                }
            default:
                completion(.failure(.unknown(errorMessage: "Unknown error")))
            }
        }.resume()
    }
}
