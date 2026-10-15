//
//  ContentView.swift
//  PackagePace
//
//  Created by Sebastian Sato on 10/8/26.
//

import SwiftUI

struct ContentView: View {
    @State private var page: Int = 0
    var body: some View {
        if (page == 0) {
            MainScreen(page: $page)
        }
        else if (page == 1) {
            BatchScreen(page: $page)
        }
        else if (page == 2) {
            ResultsScreen(page: $page)
        }
        else if (page == 3) {
            EntryScreen(page: $page)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
