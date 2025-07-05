//
//  ContentView.swift
//  EvStationFinder
//
//  Created by Ely Assumpcao Ndiaye on 05/07/25.
//

import SwiftUI

struct ContentView: View {
    @State private var zipCode: String = ""
    
    let countryList = ["Brasil", "Estados Unidos", "Canadá", "França", "Alemanha"]
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        TextField("Type the zip Code", text: $zipCode)
                            .padding(.leading)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)

                        Button(action: {
                            print("zip code: \(zipCode)")
                        }) {
                            Image(systemName: "magnifyingglass")
                        }
                        .padding(.trailing)
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()

                    List(countryList, id: \.self) { item in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item).font(.headline)
                            Text("Estação").font(.subheadline)
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
    ContentView()
}

