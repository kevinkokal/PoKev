//
//  RequestError.swift
//  PokeKev
//
//  Created by Kevin Kokal on 01/23/2024.
//

enum RequestError: Error {
    case decode(errorDescription: String)
    case invalidURL
    case noResponse
    case teapot
    case unauthorized
    case unexpectedStatusCode
    case unknown
    
    var customMessage: String {
        switch self {
        case .decode(let errorDescription):
            return "\(errorDescription)"
        case .unauthorized:
            return "Session expired"
        case .invalidURL:
            return "Invalid url"
        case .noResponse:
            return "No response"
        case .teapot:
            return "I'm a little teapot"
        case .unexpectedStatusCode:
            return "Unexpected response status code"
        case .unknown:
            return "Unknown error"
        }
    }
}
