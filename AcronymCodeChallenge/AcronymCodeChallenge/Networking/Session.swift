//
//  Session.swift
//  CodeAcronymChallenge
//
//  Created by admin on 22/03/2022.
//

import Foundation

protocol Session {
    func requestData(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

extension URLSession: Session {
    
    func requestData(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        self.dataTask(with: request) { data, response, error in
            completion(data, response, error)
        }.resume()
    }
    
    
}
