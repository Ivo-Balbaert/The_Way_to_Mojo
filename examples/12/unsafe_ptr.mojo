from memory.unsafe_pointer import (
    UnsafePointer,
    initialize_pointee_copy,
    initialize_pointee_move,
)

# bitcasting: 
def read_chunks(owned ptr: UnsafePointer[UInt8]) -> List[List[UInt32]]:
    chunks = List[List[UInt32]]()
    # A chunk size of 0 indicates the end of the data
    chunk_size = int(ptr[])
    while (chunk_size > 0):
        # Skip the 1 byte chunk_size and get a pointer to the first
        # UInt32 in the chunk
        ui32_ptr = (ptr + 1).bitcast[UInt32]()
        chunk = List[UInt32](capacity=chunk_size)
        for i in range(chunk_size):
            chunk.append(ui32_ptr[i])
        chunks.append(chunk)
        # Move our pointer to the next byte after the current chunk
        ptr += (1 + 4 * chunk_size)
        # Read the size of the next chunk
        chunk_size = int(ptr[])
    return chunks

fn main():
    # Allocate memory to hold a value
    # var ptr: UnsafePointer[Int]
    # var ptr = UnsafePointer[Int]()
    # print(ptr[])  #program crash
    var ptr = UnsafePointer[Int].alloc(1)
    # Initialize the allocated memory
    initialize_pointee_copy(ptr, 100)
    # # Update an initialized value
    ptr[] += 10
    # Access an initialized value
    print(ptr[])  # => 110
    ptr.free()

    # Storing multiple values:
    var float_ptr = UnsafePointer[Float64].alloc(6)
    for offset in range(6):
        initialize_pointee_copy(float_ptr + offset, 0.0)
    float_ptr[2] = 3.0
    for offset in range(6):
        print(float_ptr[offset], end=", ") # => 0.0, 0.0, 3.0, 0.0, 0.0, 0.0, 

   