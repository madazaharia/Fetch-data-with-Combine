//
//  NetworkManager.swift
//  FetchDataWithCombine
//
//  Created by Madalin Zaharia on 14.03.2023.
//

import Foundation
import Combine

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private var cancellables = Set<AnyCancellable>()
    private let url = "https://dummyjson.com/users"
    
    func getData<T: Codable>(type: T.Type) -> Future<T, Error> {
        return Future<T, Error> { [weak self] promise in
            guard let self = self, let url = URL(string: self.url) else {
                return promise(.failure(NetworkError.invalidURL))
            }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { data, response in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw NetworkError.responseError
                    }
                    
                    return data
                }
                .decode(type: type, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkError.unknown))
                        }
                    }
                }, receiveValue: { data in
                    promise(.success(data))
                })
                .store(in: &self.cancellables)
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case responseError
    case unknown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "Invalid response")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "Unknown error")
        }
    }
}
