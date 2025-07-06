//
//  ContentView.swift
//  EvStationFinder
//
//  Created by Ely Assumpcao Ndiaye on 05/07/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        TextField("Type the U.S zip Code", text: $viewModel.zipCode)
                            .padding(.leading)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                        
                        Button(action: {                        
                            Task {
                                await viewModel.loadStations()
                            }
                            
                        }) {
                            Image(systemName: "magnifyingglass")
                        }
                        .padding(.trailing)
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.horizontal)
                    if viewModel.stations.isEmpty {
                        Spacer()
                        Text("Nenhuma estação carregada")
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    else {
                        List(viewModel.stations) { station in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(station.station_name).font(.headline)
                                Text("\(station.street_address), \(station.city) - \(station.state), \(station.zip)")
                                    .font(.subheadline)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                            .padding(.vertical, 4)
                        }
                        .listStyle(.plain)
                    }
                }
                .padding(.top)
            }
            .navigationTitle("EV Station Finder")
        }.alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Warning"), message: Text(viewModel.errorMessage ?? "Try again later"), dismissButton: .default(Text("OK"))) }
    }
}

#Preview {
    let service = NetworkService()
    let viewModel = HomeViewModel(service: service)
    ContentView(viewModel: viewModel)
}

