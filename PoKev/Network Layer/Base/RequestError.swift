//
//  RequestError.swift
//  PokeKev
//
//  Created by Kevin Kokal on 01/23/2024.
//

enum RequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case teapot
    case unauthorized
    case unexpectedStatusCode
    case unknown
    
    var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"
        case .unauthorized:
            return "Session expired"
        case .invalidURL:
            return "Invalid url"
        case .noResponse:
            return "No response"
        case .teapot:
            return "I'm a little teapot"
        case .unexpectedStatusCode:
            return "Unexpected status code"
        case .unknown:
            return "Unknown error"
        }
    }
}
