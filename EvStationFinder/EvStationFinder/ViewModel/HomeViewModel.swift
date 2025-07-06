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

    
    let apiKey : String = "YOUR_API_KEY"
    
    private let service : NetworkServiceProtocol
    
    
    init(service: NetworkServiceProtocol = NetworkService()) {
        self.service = service
    }
    
    func loadStations(zipCode : String) async {
        guard !zipCode.isEmpty else {
            self.errorMessage = "Zip code is required"
            return
        }
        
        
        UserDefaults.standard.set(zipCode, forKey: "LastZipCode")
        
        self.isLoading = true
        
             
            let result = await service.fetchStationList(zipCode: zipCode)
            switch result {
            case .success(let stations):
                self.stations = stations
                if stations.isEmpty {
                    showError(message: "Nenhuma estação encontrada para esse CEP.")
                           }
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        
    }
    
    private func showError(message: String) {
        self.errorMessage = message
        self.showAlert = true
    }
    
    
}
