//
//  Backend.swift
//  PackagePace
//
//  Created by Sebastian Sato on 10/12/26.
//

import Foundation
import SwiftUI

struct Backend {
    static var data_registry_initialized: Bool = false
    static var data_registry: UnsafeMutableRawPointer? = nil
    static var current_batch_number : UInt? = nil
    static var current_quantity: UInt? = nil
    static var current_focused_entry : DataItem? = nil
    static var packing_times: [Double] = []
    static var last_packing_avg: Double = 0
    
    static func init_data_registry() {
        if (!data_registry_initialized) {
            Backend.data_registry = RLIB_make_data_registry()
            data_registry_initialized = true
        }
    }
    
    static func add_data_entry(boxes: UInt, bags: UInt, start: UInt, end: UInt) {
        let new_entry: UnsafeMutableRawPointer? = RLIB_make_data_entry(current_batch_number!, current_quantity!, boxes, bags, start, end)
        RLIB_add_entry(Backend.data_registry, new_entry)
    }
    
    struct DataItem: Identifiable {
        var id: Int
        let batch_num : Int
        let quantity : Int
        let boxes : Int
        let bags : Int
        let start : UInt
        let stop : UInt
    }
    
    static func get_data() -> [DataItem] {
        var entries : [DataItem] = []
        for i in (0...RLIB_get_num_entries(data_registry)-1) {
            let current_entry : UnsafeMutableRawPointer? = RLIB_get_data_entry(data_registry, Int32(i))
            let qu = Int(RLIB_data_entry_get_quantity(current_entry))
            let bn = Int(RLIB_data_entry_get_batch_number(current_entry))
            let bx = Int(RLIB_data_entry_get_num_boxes(current_entry))
            let bg = Int(RLIB_data_entry_get_num_bags(current_entry))
            let st = UInt(RLIB_data_entry_get_start(current_entry))
            let en = UInt(RLIB_data_entry_get_end(current_entry))
            lazy var new_item: DataItem = DataItem(id: Int(i), batch_num: bn, quantity: qu, boxes: bx, bags: bg, start: st, stop: en)

            entries.append(new_item)
        }
        
        return entries
    }
    
    static func update_last_packing_avg(this_packing_avg: Double) {
        last_packing_avg = this_packing_avg
    }
    
    static func reset_avg_packing_tracking() {
        packing_times = []
    }
}

