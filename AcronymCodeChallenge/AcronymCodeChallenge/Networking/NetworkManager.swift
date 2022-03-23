//
//  NetworkManager.swift
//  CodeAcronymChallenge
//
//  Created by admin on 22/03/2022.
//

import Foundation

protocol Network {
    var session: Session { get }
    func getModel<T: Decodable>(request: URLRequest?, completion: @escaping (Result<T, Error>) -> Void)
}

class NetworkManager: Network {
    
    var session: Session
    
    init(session: Session = URLSession.shared) {
        self.session = session
    }
    
    func getModel<T: Decodable>(request: URLRequest?, completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let request = request else {
            completion(.failure(NetworkError.badRequest))
            return
        }
        
        self.session.requestData(request: request) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, !(200..<300).contains(httpResponse.statusCode) {
                completion(.failure(NetworkError.badServerResponse(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.missingData))
                return
            }
            
            do {
                let model = try JSONDecoder().decode(T.self, from: data)
                completion(.success(model))
            } catch {
                completion(.failure(error))
            }
        }
        
        return
    }
    
}
