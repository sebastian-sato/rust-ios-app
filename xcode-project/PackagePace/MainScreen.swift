//
//  MainScreen.swift
//  PackagePace
//
//  Created by Sebastian Sato on 10/8/26.
//

import SwiftUI

struct MainScreen: View {
    @Binding var page: Int
    
    @State var batch_num_str: String = ""
    @State var quantity_str: String = ""
    
    @State var num_box_str: String = ""
    @State var num_bag_str: String = ""
    
    @State var shows_alert: Bool = false
    
    var body: some View {
        VStack {
            Group {
                HStack {
                    TextField("Batch Number", text:$batch_num_str)
                }
                HStack {
                    TextField("Product Quantity", text:$quantity_str)
                }
            }
                .frame(width: 250, height: 50)
                .multilineTextAlignment(.center)
                .bold()
                .background {
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .stroke(lineWidth: 2)
                }
            // End group
            
            if (Backend.data_registry_initialized) {
                let avg_packing_time: Double = get_avg_pack_time()
                Text("Average pack time:")
                    .bold()
                Text(String(avg_packing_time) + " seconds")
            }
            
            Group {
                Button("Start") {
                    var success: Bool =  true
                    
                    if let batch_num = NumberFormatter().number(from: batch_num_str) {
                        Backend.current_batch_number = batch_num.uintValue
                    } else {
                        success = false
                    }
                    
                    if let quantity = NumberFormatter().number(from: quantity_str) {
                        Backend.current_quantity = quantity.uintValue
                    } else {
                        success = false
                    }
                    
                    if success {
                        page = 1
                        Backend.reset_avg_packing_tracking()
                        Backend.init_data_registry()
                    } else {
                        shows_alert.toggle()
                    }
                }
                .alert(isPresented: self.$shows_alert) {
                    Alert(title: Text("Invalid input."))
                }
                if (Backend.data_registry_initialized) {
                    Button("View results") {
                        page = 2
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 5))
            
        }
        .onAppear() {
            UIApplication.shared.isIdleTimerDisabled = true
        }
    }
}

func get_avg_pack_time() -> Double {
    var sum: Double = 0.0
    if (Backend.packing_times.count > 0) {
        for i in 0...Backend.packing_times.count-1 {
            sum += Backend.packing_times[i]
        }
        return round(1000 * (sum / Double(Backend.packing_times.count))) / 1000
    }
    return 0.0
}
