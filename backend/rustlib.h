void* RLIB_make_data_registry();
int RLIB_get_num_entries(void* registry_ptr);
void RLIB_add_entry(void* registry_ptr, void* entry_ptr);
void* RLIB_make_data_entry(
    unsigned long batch,
    unsigned long quantity,
    unsigned long boxes,
    unsigned long bags,
    unsigned long start,
    unsigned long end
);
void* RLIB_get_data_entry(void* registry_ptr, int index);
unsigned long RLIB_data_entry_get_batch_number(void* entry_ptr);
unsigned long RLIB_data_entry_get_quantity(void* entry_ptr);
unsigned long RLIB_data_entry_get_num_boxes(void* entry_ptr);
unsigned long RLIB_data_entry_get_num_bags(void* entry_ptr);
unsigned long RLIB_data_entry_get_start(void* entry_ptr);
unsigned long RLIB_data_entry_get_end(void* entry_ptr);