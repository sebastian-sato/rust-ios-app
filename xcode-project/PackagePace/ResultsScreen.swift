//
//  Results.swift
//  PackagePace
//
//  Created by Sebastian Sato on 10/13/26.
//

import SwiftUI

struct ResultsScreen: View {
    @Binding var page: Int
    
    var body: some View {
        VStack {
            List(Backend.get_data()) { item in
                Button(String(item.batch_num)) {
                    Backend.current_focused_entry = item
                    page = 3
                }
            }
            Button("Back") {
                page = 0
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 5))
        }
    }
}
