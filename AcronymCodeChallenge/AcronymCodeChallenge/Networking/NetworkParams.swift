//
//  NetworkParams.swift
//  CodeAcronymChallenge
//
//  Created by admin on 22/03/2022.
//

import Foundation

enum NetworkParams {
    
    private enum NetworkConstants: String {
        case baseURL = "http://www.nactem.ac.uk/software/acromine/dictionary.py"
        case acronym = "sf"
    }
    
    // In case this app needs more functionality here, you can add it
    case acronymSearch(String)
    
    var urlRequest: URLRequest? {
        switch self {
        case .acronymSearch(let searchQuery):
            var components = URLComponents(string: NetworkConstants.baseURL.rawValue)
            components?.queryItems = [URLQueryItem(name: NetworkConstants.acronym.rawValue, value: searchQuery)]
            guard let url = components?.url else { return nil }
            return URLRequest(url: url)
        }
        
        
    }
    
    
}
