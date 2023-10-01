from python import Python, PythonObject    # 0


fn plot_from_mojo(values: PythonObject) raises:   # 9
    print(values.__class__.__name__)  # => ndarray
    let plt = Python.import_module("matplotlib.pyplot")   # 10  
    _ = plt.plot(values)                          # 11              
    _ = plt.show()                                # 12

fn numpy_array_from_mojo() raises -> PythonObject:
    let np = Python.import_module("numpy")   # 3    

    let x = PythonObject([])         # 4           
    let range_size: Int = 256        # 5           
    for i in range(range_size):      # 6          
        _ = x.append(i)              # 7 
    print(x)   # => [0, 1, 2, 3, 4, ..., 253, 254, 255]

    return np.cos(np.array(x)*np.pi*2.0/256.0)  # 8 

def main():            
    let results = numpy_array_from_mojo()   # 1    
    plot_from_mojo(results)                 # 2    
    