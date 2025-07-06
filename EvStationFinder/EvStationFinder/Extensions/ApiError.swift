//
//  ApiError.swift
//  EvStationFinder
//
//  Created by Ely Assumpcao Ndiaye on 05/07/25.
//

import Foundation

public enum ApiError: Error {
    case notFound
    case unauthorized
    case badRequest
    case tooManyRequests
    case otherErrors
    case connectionFailure
    case serverError
    case timeout
    case bodyNotFound
    case malformedRequest(_: String?)
    case decodeError(_: Error)
    case unknown(_: Error?)
    
    var message: String {
        switch self {
        case .badRequest:
            return HomeStrings.stationNotFound
        case .timeout, .connectionFailure:
            return HomeStrings.verifyYourConnection
        default:
            return HomeStrings.tryAgainLater
        }
    }
}
