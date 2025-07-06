//
//  EvStationFinderApp.swift
//  EvStationFinder
//
//  Created by Ely Assumpcao Ndiaye on 05/07/25.
//

import SwiftUI

@main
struct EvStationFinderApp: App {
    var body: some Scene {
        WindowGroup {
            let service = NetworkService()
            let viewModel = HomeViewModel(service: service)

            ContentView(viewModel: viewModel)
        }
    }
}
