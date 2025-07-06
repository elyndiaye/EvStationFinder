//
//  EvStationResponse.swift
//  EvStationFinder
//
//  Created by Ely Assumpcao Ndiaye on 05/07/25.
//

import Foundation

struct EvStationResponse: Codable {
    let fuel_stations: [EvStation]
}

struct EvStation: Codable, Identifiable {
    let id: Int
    let station_name: String
    let street_address: String
    let city: String
    let state: String
    let zip: String
    let latitude: Double
    let longitude: Double
}
