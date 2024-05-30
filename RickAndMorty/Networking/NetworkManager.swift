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
    func getCombined<T: Decodable>(urlStrings: [String], responseType: T.Type, completion: @escaping (Result<[T], NetworkError>) -> Void)
    func getCombinedCharacters<T: Decodable>(urlStrings: [String], responseType: T.Type, completion: @escaping (Result<[T], NetworkError>) -> Void)
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
    
    private func get<T: Decodable>(url: URL, responseType: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
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
    
    func getCombined<T: Decodable>(urlStrings: [String], responseType: T.Type, completion: @escaping (Result<[T], NetworkError>) -> Void) {
        let group = DispatchGroup()
        var results: [T] = []
        var encounteredError: NetworkError?
        
        for urlString in urlStrings {
            guard let url = URL(string: urlString) else {
                completion(.failure(.badURL))
                return
            }
            
            group.enter()
            get(url: url, responseType: responseType) { result in
                defer { group.leave() }
                switch result {
                case .success(let decodedResponse):
                    results.append(decodedResponse)
                case .failure(let error):
                    encounteredError = error
                }
            }
        }
        
        group.notify(queue: .main) {
            if let error = encounteredError {
                completion(.failure(error))
            } else {
                completion(.success(results))
            }
        }
    }

    func getCombinedCharacters<T: Decodable>(urlStrings: [String], responseType: T.Type, completion: @escaping (Result<[T], NetworkError>) -> Void) {
        let group = DispatchGroup()
        var episodeCharacters: [T] = []
        var encounteredError: NetworkError?
        
        for urlString in urlStrings {
            guard let url = URL(string: urlString) else {
                completion(.failure(.badURL))
                return
            }
            
            group.enter()
            get(url: url, responseType: responseType) { result in
                defer { group.leave() }
                switch result {
                case .success(let decodedResponse):
                    episodeCharacters.append(decodedResponse)
                case .failure(let error):
                    encounteredError = error
                }
            }
        }
        
        group.notify(queue: .main) {
            if let error = encounteredError {
                completion(.failure(error))
            } else {
                completion(.success(episodeCharacters))
            }
        }
    }

}
