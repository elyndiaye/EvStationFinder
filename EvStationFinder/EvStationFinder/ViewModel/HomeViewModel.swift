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
        guard isValidZipCode() else { return }
        
        UserDefaults.standard.set(zipCode, forKey: "LastZipCode")
        
        self.isLoading = true
        
        let result = await service.fetchStationList(zipCode: zipCode)
        
        isLoading = false
        
        handleResult(result)
        
    }
    
    private func isValidZipCode() -> Bool {
           if zipCode.isEmpty {
               showError(message: HomeStrings.zipCodeIsRequired)
               return false
           }

           if zipCode.count != 5 || Int(zipCode) == nil {
               showError(message: HomeStrings.zipCodeNeedToBeValid)
               return false
           }

           return true
       }


       private func handleResult(_ result: Result<[EvStation], ApiError>) {
           switch result {
           case .success(let stations):
               self.stations = stations
               if stations.isEmpty {
                   showError(message: HomeStrings.noStationsFoundZipCode)
               }
           case .failure(let error):
               showError(message: error.message)
           }
       }
    
    private func showError(message: String) {
        self.errorMessage = message
        self.showAlert = true
    }
    
    
}
