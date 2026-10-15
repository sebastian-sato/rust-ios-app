//
//  BatchScreen.swift
//  PackagePace
//
//  Created by Sebastian Sato on 10/8/26.
//

import SwiftUI

struct BatchScreen: View {
    @State private var startDate = Date()
    @State private var startTime = UInt(Date().timeIntervalSince1970)
    @State private var elapsedTime: Double = 0.0
    
    @State private var num_bags: UInt = 0
    @State private var num_boxes: UInt = 0
    
    @State private var last_pack = Date()
    
    let timer = Timer.publish(every: 0.01, on: .main, in: .common)
        .autoconnect()
    
    @Binding var page: Int
    var body: some View {
        VStack {
            HStack {
                
            }
            HStack {
                Text(String(format: "%.2f", elapsedTime))
                    .font(.largeTitle)
            }
            HStack {
                Group {
                    Text(String(num_boxes))
                    Text(String(num_bags))
                }
                .frame(width: 50, height: 50)
                .multilineTextAlignment(.center)
                .bold()
                .background {
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .stroke(lineWidth: 2)
                }
            }
            
            Divider()
            
            HStack {
                Group {
                    Button("Pack Box") {
                        num_boxes += 1
                        last_pack = add_packing_interval(last_pack: last_pack)
                    }
                    Button("Pack Bag") {
                        num_bags += 1
                        last_pack = add_packing_interval(last_pack: last_pack)
                    }
                }
                .frame(width:100,height:100)
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 5))
            }
            HStack {
                Button("Done") {
                    //elapsedTime = Date().timeIntervalSince(startTime)
                    let endTime = UInt(Date().timeIntervalSince1970)
                    Backend.add_data_entry(boxes: num_boxes, bags: num_bags, start: startTime, end: endTime)
                    //print(Backend.gne())
                    page = 0
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 5))
            }
        }
        .onReceive(timer) {
            _ in elapsedTime = Date().timeIntervalSince(startDate)
        }
        .onAppear() {
            UIApplication.shared.isIdleTimerDisabled = true
        }
    }
}

func add_packing_interval(last_pack: Date) -> Date {
    Backend.packing_times.append(Date().timeIntervalSince(last_pack))
    return Date()
}
