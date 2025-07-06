//
//  HomeViewModel.swift
//  EvStationFinder
//
//  Created by Ely Assumpcao Ndiaye on 05/07/25.
//


import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var stations : [EvStation] = []
    @Published var isLoading : Bool = false
    @Published var errorMessage : String?
    @Published var showAlert =  false
    @Published var zipCode: String = Foundation.UserDefaults.standard.string(forKey: "LastZipCode") ?? ""
    
    
    private let service : NetworkServiceProtocol
    
    
    init(service: NetworkServiceProtocol = NetworkService()) {
        self.service = service
    }
    
    func loadStations() async {
        guard !zipCode.isEmpty else {
            showError(message: HomeStrings.zipCodeIsRequired)
            zipCode = ""
            return
        }
        
        guard zipCode.count == 5 else {
            showError(message: HomeStrings.zipCodeNeedToBeValid)
            zipCode = ""
            return
        }
        
        
        UserDefaults.standard.set(zipCode, forKey: "LastZipCode")
        
        self.isLoading = true
        
        let result = await service.fetchStationList(zipCode: zipCode)
        
        isLoading = false
        
        switch result {
        case .success(let stations):
            self.stations = stations
            if stations.isEmpty {
                showError(message: HomeStrings.noStatitionsFoundZipCode)
            }
        case .failure(let error):
            showError(message:  error.message)
        }
        
    }
    
    private func showError(message: String) {
        self.errorMessage = message
        self.showAlert = true
    }
    
    
}
