//
//  NetworkError.swift
//  CodeAcronymChallenge
//
//  Created by admin on 22/03/2022.
//

import Foundation

enum NetworkError: Error, Equatable {
    case missingData
    case badServerResponse(Int)
    case badRequest
    case emptyResult
}
