//
//  StationDetailView.swift
//  EvStationFinder
//
//  Created by Ely Assumpcao Ndiaye on 05/07/25.
//

import SwiftUI
import MapKit

struct StationDetailView: View {
    let station: EvStation
    private var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: station.latitude, longitude: station.longitude)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.space4) {
            Text(station.station_name)
                .font(.title)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: Spacing.space2) {
                Text("Street Address: \(station.street_address)")
                    .font(.subheadline)
                Text("City: \(station.city)")
                    .font(.subheadline)
                Text("State: \(station.state)")
                    .font(.subheadline)
                Text("Zip: \(station.zip)")
                    .font(.subheadline)
            }
            .padding(.top, 10)
            
            Button(action: {
                openAppleMaps()
            }) {
                Label(StationDetailStrings.openIMaps, systemImage: "map")
                    .foregroundColor(.blue)
            }
            .padding(.top, Spacing.space4)
            Spacer()
        }
        .padding()
        .navigationTitle(StationDetailStrings.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func openAppleMaps() {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = station.station_name
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
}

#Preview {
    StationDetailView(station: EvStation(id: 1, station_name: "Luxe Rodeo", street_address: "360 N Rodeo", city: "Beverly Hills", state: "CA", zip: "90210", latitude: 34.24831915271937, longitude: -118.44384765625))
}
