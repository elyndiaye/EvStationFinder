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
                        TextField(HomeStrings.typeZipCode, text: $viewModel.zipCode)
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
                    if viewModel.isLoading {
                        ProgressView(HomeStrings.loadingStations)
                            .padding()
                    } else if viewModel.stations.isEmpty {
                        Spacer()
                        Text(HomeStrings.noStationsLoaded)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    else {
                        List(viewModel.stations) { station in
                            NavigationLink(destination: StationDetailView(station: station)) {
                                VStack(alignment: .leading, spacing: Spacing.space0) {
                                    Text(station.station_name).font(.headline)
                                    Text("\(station.street_address), \(station.city) - \(station.state), \(station.zip)")
                                        .font(.subheadline)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(Spacing.space1)
                                .padding(.vertical, Spacing.space0)
                                
                            }
                        }
                        .listStyle(.plain)
                    }
                }
                .padding(.top)
            }
            .navigationTitle("EV Station Finder")
        }.alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text(HomeStrings.attention),
                  message: Text(viewModel.errorMessage ?? "Try again later"),
                  dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    let service = NetworkService()
    let viewModel = HomeViewModel(service: service)
    ContentView(viewModel: viewModel)
}

