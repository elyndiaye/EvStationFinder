//
//  ContentView.swift
//  EvStationFinder
//
//  Created by Ely Assumpcao Ndiaye on 05/07/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: HomeViewModel
    @State private var zipCode: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        TextField("Type the U.S zip Code", text: $zipCode)
                            .padding(.leading)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)

                        Button(action: {
                            print("zip code: \(zipCode)")
                            Task {
                                               await viewModel.loadStations(zipCode: zipCode)
                                           }
                            
                        }) {
                            Image(systemName: "magnifyingglass")
                        }
                        .padding(.trailing)
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()

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
                .padding(.top)
            }
            .navigationTitle("EV Station Finder")
        }
    }
}

#Preview {
    let service = NetworkService()
    let viewModel = HomeViewModel(service: service)
    ContentView(viewModel: viewModel)
}

