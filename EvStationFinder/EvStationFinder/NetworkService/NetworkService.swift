//
//  NetworkService.swift
//  EvStationFinder
//
//  Created by Ely Assumpcao Ndiaye on 05/07/25.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchStationList(zipCode: String) async -> Result<[EvStation], ApiError>
}


class NetworkService: NetworkServiceProtocol {
   // private let baseURL = "https://developer.nrel.gov/api/alt-fuel-stations/v1.json"
    private let baseURL = "https://developer.nrel.gov/api/alt-fuel-stations/v1.json"
    private let apiKey = "0ZF8mMP7vb8zqFdaX38tJ7X9JDkCxRTZbMut7uSk"

    func fetchStationList(zipCode: String) async -> Result<[EvStation], ApiError> {
        
        var fullUrl = URLComponents(string: baseURL)
        fullUrl?.queryItems = [
                    URLQueryItem(name: "fuel_type", value: "ELEC"),
                    URLQueryItem(name: "zip", value: zipCode),
                    URLQueryItem(name: "api_key", value: apiKey)
                ]
 

        guard let url =  fullUrl?.url else {
            return .failure(.malformedRequest("URL inválida"))
        }
        

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.unknown(nil))
            }
            

            switch httpResponse.statusCode {
            case 200:
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(EvStationResponse.self, from: data)
                return .success(decoded.fuel_stations)
            case 400:
                return .failure(.badRequest)
            case 401:
                return .failure(.unauthorized)
            case 404:
                return .failure(.notFound)
            case 429:
                return .failure(.tooManyRequests)
            case 500...599:
                return .failure(.serverError)
            default:
                return .failure(.otherErrors)
            }

        } catch {
            return .failure(.decodeError(error))
        }
    }

}
