mod internal {
    pub struct DataRegistry {
        pub data: Vec<DataEntry>
    }

    impl Default for DataRegistry {
        fn default() -> Self {
            DataRegistry {
                data: Vec::new()
            }
        }
    }

    impl DataRegistry {
        pub fn add_entry(&mut self, de: DataEntry) {
            self.data.push(de);
        }
    }

    pub struct DataEntry {
        pub batch_number: std::ffi::c_ulong,
        pub quantity: std::ffi::c_ulong,
        pub boxes: std::ffi::c_ulong,
        pub bags: std::ffi::c_ulong,
        pub start: std::ffi::c_ulong,
        pub end: std::ffi::c_ulong,
    }

    impl Clone for DataEntry {
        fn clone(&self) -> Self {
            DataEntry {
                batch_number: self.batch_number,
                quantity: self.quantity,
                boxes: self.boxes,
                bags: self.bags,
                start: self.start,
                end: self.end
            }
        }
    }
}

mod api {
    use super::internal::DataRegistry;
    use super::internal::DataEntry;

    #[unsafe(no_mangle)]
    pub extern "C" fn RLIB_make_data_registry() -> *mut std::ffi::c_void {
        let boxed_dr: Box<DataRegistry> = Box::new(DataRegistry::default());
        Box::into_raw(boxed_dr).cast()
    }

    #[unsafe(no_mangle)]
    pub extern "C" fn RLIB_get_num_entries(registry_ptr: *mut std::ffi::c_void) -> std::ffi::c_int {
        let dr: *mut DataRegistry = registry_ptr.cast::<DataRegistry>().clone();
        unsafe { (*dr).data.len() as std::ffi::c_int }
    }

    #[unsafe(no_mangle)]
    pub extern "C" fn RLIB_add_entry(mut registry_ptr: *mut std::ffi::c_void, data_entry_ptr: *mut std::ffi::c_void) {
        let mut dr: Box<DataRegistry> = unsafe { Box::from_raw(registry_ptr.cast::<DataRegistry>()) };
        let de: Box<DataEntry> = unsafe { Box::from_raw(data_entry_ptr.cast::<DataEntry>()) };
        dr.add_entry(*de);
        let _ = std::mem::replace(&mut registry_ptr, Box::into_raw(dr).cast());
    }

    #[unsafe(no_mangle)]
    pub extern "C" fn RLIB_make_data_entry (
        bn: std::ffi::c_ulong,
        q: std::ffi::c_ulong,
        bx: std::ffi::c_ulong,
        bg: std::ffi::c_ulong,
        st: std::ffi::c_ulong,
        en: std::ffi::c_ulong,
    ) -> *mut std::ffi::c_void {
        let boxed_entry: Box<DataEntry> = Box::new(DataEntry {
            batch_number: bn,
            quantity: q,
            boxes: bx,
            bags: bg,
            start: st,
            end: en
        });

        Box::into_raw(boxed_entry).cast()
    }

    #[unsafe(no_mangle)]
    pub extern "C" fn RLIB_get_data_entry(registry_ptr: *mut std::ffi::c_void, index: std::ffi::c_int) -> *mut std::ffi::c_void {
        let vector_reference: &Vec<DataEntry> = unsafe { &(*registry_ptr.cast::<DataRegistry>()).data }; // this part tripped me up, cuz I kept accidentally consuming the registry into the function, rust is hard :P
        let entry: DataEntry = vector_reference[index as usize].clone();
        Box::into_raw(Box::new(entry)).cast()
    }

    #[unsafe(no_mangle)]
    pub extern "C" fn RLIB_data_entry_get_batch_number(data_entry_ptr: *mut std::ffi::c_void) -> std::ffi::c_ulong {
        let de: *mut DataEntry = data_entry_ptr.cast::<DataEntry>().clone();
        unsafe { (*de).batch_number }
    }

    #[unsafe(no_mangle)]
    pub extern "C" fn RLIB_data_entry_get_quantity(data_entry_ptr: *mut std::ffi::c_void) -> std::ffi::c_ulong {
        let de: *mut DataEntry = data_entry_ptr.cast::<DataEntry>().clone();
        unsafe{ (*de).quantity }
    }

    #[unsafe(no_mangle)]
    pub extern "C" fn RLIB_data_entry_get_num_boxes(data_entry_ptr: *mut std::ffi::c_void) -> std::ffi::c_ulong {
        let de: *mut DataEntry = data_entry_ptr.cast::<DataEntry>().clone();
        unsafe{ (*de).boxes }
    }

    #[unsafe(no_mangle)]
    pub extern "C" fn RLIB_data_entry_get_num_bags(data_entry_ptr: *mut std::ffi::c_void) -> std::ffi::c_ulong {
        let de: *mut DataEntry = data_entry_ptr.cast::<DataEntry>().clone();
        unsafe{ (*de).bags }
    }

    #[unsafe(no_mangle)]
    pub extern "C" fn RLIB_data_entry_get_start(data_entry_ptr: *mut std::ffi::c_void) -> std::ffi::c_ulong {
        let de: *mut DataEntry = data_entry_ptr.cast::<DataEntry>().clone();
        unsafe{ (*de).start }
    }

    #[unsafe(no_mangle)]
    pub extern "C" fn RLIB_data_entry_get_end(data_entry_ptr: *mut std::ffi::c_void) -> std::ffi::c_ulong {
        let de: *mut DataEntry = data_entry_ptr.cast::<DataEntry>().clone();
        unsafe{ (*de).end }
    }
}

#[cfg(test)]
mod tests {
    use super::api::*;

    #[test]
    fn test() {
        let dr_ptr: *mut std::ffi::c_void = RLIB_make_data_registry();
        let de_ptr: *mut std::ffi::c_void = RLIB_make_data_entry(
            1234,
            765432,
            765432,
            87654,
            76543,
            87654
        );
        RLIB_add_entry(dr_ptr, de_ptr);
        assert_eq!(RLIB_get_num_entries(dr_ptr), 1);
        let de_ptr_2: *mut std::ffi::c_void = RLIB_make_data_entry(
            87654,
            78765,
            7654,
            87654,
            987,
            34567
        );
        RLIB_add_entry(dr_ptr, de_ptr_2);
        assert_eq!(RLIB_get_num_entries(dr_ptr), 2);

        let retrieved_de_ptr_0: *mut std::ffi::c_void = RLIB_get_data_entry(dr_ptr, 0);
        let batch_0: std::ffi::c_ulong = RLIB_data_entry_get_batch_number(retrieved_de_ptr_0);
        let quantity_0: std::ffi::c_ulong = RLIB_data_entry_get_quantity(retrieved_de_ptr_0);
        let boxes_0: std::ffi::c_ulong = RLIB_data_entry_get_num_boxes(retrieved_de_ptr_0);
        let bags_0: std::ffi::c_ulong = RLIB_data_entry_get_num_bags(retrieved_de_ptr_0);
        let start_0: std::ffi::c_ulong = RLIB_data_entry_get_start(retrieved_de_ptr_0);
        let end_0: std::ffi::c_ulong = RLIB_data_entry_get_end(retrieved_de_ptr_0);

        assert_eq!(batch_0, 1234);
        assert_eq!(quantity_0, 765432);
        assert_eq!(boxes_0, 765432);
        assert_eq!(bags_0, 87654);
        assert_eq!(start_0, 76543);
        assert_eq!(end_0, 87654);
        
        let retrieved_de_ptr_1: *mut std::ffi::c_void = RLIB_get_data_entry(dr_ptr, 1);
        let batch_1: std::ffi::c_ulong = RLIB_data_entry_get_batch_number(retrieved_de_ptr_1);
        let quantity_1: std::ffi::c_ulong = RLIB_data_entry_get_quantity(retrieved_de_ptr_1);
        let boxes_1: std::ffi::c_ulong = RLIB_data_entry_get_num_boxes(retrieved_de_ptr_1);
        let bags_1: std::ffi::c_ulong = RLIB_data_entry_get_num_bags(retrieved_de_ptr_1);
        let start_1: std::ffi::c_ulong = RLIB_data_entry_get_start(retrieved_de_ptr_1);
        let end_1: std::ffi::c_ulong = RLIB_data_entry_get_end(retrieved_de_ptr_1);

        assert_eq!(batch_1, 87654);
        assert_eq!(quantity_1, 78765);
        assert_eq!(boxes_1, 7654);
        assert_eq!(bags_1, 87654);
        assert_eq!(start_1, 987);
        assert_eq!(end_1, 34567);
    }
}