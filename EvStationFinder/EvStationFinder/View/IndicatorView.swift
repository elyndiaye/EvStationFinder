//
//  IndicatorView.swift
//  EvStationFinder
//
//  Created by Ely Assumpcao Ndiaye on 13/09/25.
//

import SwiftUI

struct IndicatorView: View {
    let numberOfPages: Int
      let currentIndex: Int
      let activeColor: Color = .primary
      let inactiveColor: Color = .gray

      var body: some View {
          HStack(spacing: 6) {
              ForEach(0..<numberOfPages, id: \.self) { index in
                  Circle()
                      .fill(index == currentIndex ? activeColor : inactiveColor.opacity(0.5))
                      .frame(width: 8, height: 8)
              }
          }
      }
}

#Preview {
    IndicatorView(numberOfPages: 2, currentIndex: 0)
}
