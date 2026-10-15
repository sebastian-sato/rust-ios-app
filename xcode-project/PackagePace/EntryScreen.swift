//
//  EntryScreen.swift
//  PackagePace
//
//  Created by Sebastian Sato on 10/15/26.
//

import SwiftUI

struct EntryScreen: View {
    @Binding var page: Int
    
    var body: some View {
        VStack {
            Text("Batch Number: " + String(Backend.current_focused_entry!.batch_num))
                .bold()
                .font(
                    .system(size: 25)
                )
            Text("Products shipped: " + String(Backend.current_focused_entry!.quantity))
            Text("Boxes: " + String(Backend.current_focused_entry!.boxes))
            Text("Bags: " + String(Backend.current_focused_entry!.bags))
            
            let start_date = Date(timeIntervalSince1970: Double(Backend.current_focused_entry!.start))
            let stop_date = Date(timeIntervalSince1970: Double(Backend.current_focused_entry!.stop))
            
            let formatted_start = start_date.formatted(date: .omitted, time: .complete)
            let formatted_stop = stop_date.formatted(date: .omitted, time: .complete)
            
            Text("Start date: " + formatted_start)
            Text("Stop date: " + formatted_stop)
            Text("Elapsed time: " + formatted_time_interval(seconds: Int(Backend.current_focused_entry!.stop) - Int(Backend.current_focused_entry!.start)))
            
            Button("Back") {
                page = 2
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 5))
        }
    }
}

func formatted_time_interval(seconds: Int) -> String {
    let hours: Int = seconds / 3600
    let minutes: Int = (seconds - (hours * 3600)) / 60
    let remaining_seconds: Int = seconds - (minutes * 60) - (hours * 3600)
    return String(hours) + ":" + String(minutes) + ":" + String(remaining_seconds)
}
