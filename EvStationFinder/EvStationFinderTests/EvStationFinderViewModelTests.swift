//
//  EvStationFinderTests.swift
//  EvStationFinderTests
//
//  Created by Ely Assumpcao Ndiaye on 05/07/25.
//

import XCTest
@testable import EvStationFinder

class NetworkServiceSpy: NetworkServiceProtocol {
    var mockReturnError = false
    var stationsMock: [EvStation] = []
    func fetchStationList(zipCode: String) async -> Result<[EvStationFinder.EvStation], EvStationFinder.ApiError> {
        if mockReturnError {
            return .failure(.badRequest)
        } else {
            return .success(stationsMock)
        }
    }
    
}

@MainActor
final class HomeViewModelTests: XCTestCase {
    
    
    func testShowisEmpty_WhenZipCodeIsEmpty_ShouldShowsError() async {
        let mockService = NetworkServiceSpy()
        let viewModel = HomeViewModel(service: mockService)
        viewModel.zipCode = ""
        
        await viewModel.loadStations()
        
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.errorMessage, "Zip code is required")
    }
    
    func testShowIsInvalid_WhenZipCodeIsNotValid_ShouldShowsError() async {
        let mockService = NetworkServiceSpy()
        let viewModel = HomeViewModel(service: mockService)
        viewModel.zipCode = "0X0"
        
        await viewModel.loadStations()
        
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.errorMessage, "Zip code need to be valid.")
    }
    
    func testShowStations_WhenZipCodeIsValid_ShouldShowsStations() async {
        let mockService = NetworkServiceSpy()
        let viewModel = HomeViewModel(service: mockService)
        
        mockService.stationsMock = [
            .init(id: 1, station_name: "Luxe Rodeo", street_address: "360 N Rodeo", city: "Beverly Hills", state: "CA", zip: "90210", latitude: 34.24831915271937, longitude: -118.44384765625)
        ]
        
        viewModel.zipCode = "10001"
        
        await viewModel.loadStations()
        
        XCTAssertFalse(viewModel.showAlert)
        XCTAssertEqual(viewModel.stations.count, 1)
        XCTAssertEqual(viewModel.stations[0].station_name, "Luxe Rodeo")
        
    }
    
    func testError_WhenFetchingStationsFails_ShouldShowsError() async {
        let mockService = NetworkServiceSpy()
        mockService.mockReturnError = true
        
        let viewModel = HomeViewModel(service: mockService)
        viewModel.zipCode = "10001"
        
        await viewModel.loadStations()
        
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.errorMessage, "Station not found")
    }
    
}
