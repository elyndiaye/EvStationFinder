//
//  StationDetailView.swift
//  EvStationFinder
//
//  Created by Ely Assumpcao Ndiaye on 05/07/25.
//

import SwiftUI

struct StationDetailView: View {
    let station: EvStation
    
    var body: some View {
           VStack(alignment: .leading, spacing: 20) {
               Text(station.station_name)
                   .font(.title)
                   .fontWeight(.bold)
               
               VStack(alignment: .leading, spacing: Spacing.space2) {
                               Text(" Street Address: \(station.street_address)")
                                   .font(.subheadline)
                               Text(station.city)
                                   .font(.subheadline)
                               Text(station.state)
                                   .font(.subheadline)
                               Text(station.zip)
                                   .font(.subheadline)
                           }
                           .padding(.top, 10)
               Spacer()
           }
           .padding()
           .navigationTitle("Station Details")
           .navigationBarTitleDisplayMode(.inline)
       }
}

#Preview {
    StationDetailView(station: EvStation(id: 1, station_name: "Luxe Rodeo", street_address: "360 N Rodeo", city: "Beverly Hills", state: "CA", zip: "90210"))
}
