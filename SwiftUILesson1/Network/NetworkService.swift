//
//  Network.swift
//  SwiftUILesson1
//
//  Created by Marina Zhukova on 14.08.2024.
//

import Foundation

class NetworkService {
    
    var configuration: URLSessionConfiguration?
    
    func request<T: Decodable>(urlRequest: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 1002, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            let decoder = JSONDecoder()

            do {
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch let decodingError {
                print("Failed to decode JSON: \(decodingError.localizedDescription)")
                completion(.failure(decodingError))
            }
        }.resume()
    }
}

