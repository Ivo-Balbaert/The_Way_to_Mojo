# 8 Python integration

Mojo allows us to leverage the huge Python ecosystem of libraries and tools.
You can use Python for what it's good at, especially graph plotting and GUIs and for things that do not yet exist or are more difficult to rewrite in Mojo.
That way, a Python project can be gradually migrated to Mojo.

## 8.0 Comparing the same program in Python and Mojo
See `adding.py`:
```mojo
def add(x, y):
    return x + y

z = add(3, 5)
print(z) # => 8
```
versus `adding.mojo`:
```mojo
fn add(x: Int, y: Int) -> Int:
    return x + y

fn main():
    let z = add(3, 5)
    print(z) # => 8
```

Let's do a compute time comparison over 1_000_000 additions (see adding_timing.py and adding_timing.mojo).  
Mojo is 2_422_525 times faster than Python!

## 8.1 Running Python code
To execute a Python expression, you can use the `evaluate` method:  

See `python1.mojo`:
```mojo
from python import Python

fn main() raises:
    var x = Python.evaluate('5 + 10')   # 1 - this is of type `PythonObject`
    print(x)   # => 15

    let py = Python()
    let py_string = py.evaluate("'This string was built' + ' inside of python'")
    print(py_string)  # => This string was built inside of python
 
    let pybt = Python.import_module("builtins") # 2
    _ = pybt.print("this uses the python print keyword") # => this uses the python print keyword

    _ = pybt.print(pybt.type(x))  # => <class 'int'>
    _ = pybt.print(pybt.id(x))    # => 139787831339296
```

If you leave out the keyword `raises`, you get the error:  
```
cannot call function that may raise in a context that cannot raisemojo
python1.mojo(4, 28): try surrounding the call in a 'try' block
python1.mojo(3, 1): or mark surrounding function as 'raises'
```

Apparently, Mojo warns you that `Python.evaluate` could raise an error, that Mojo should catch.

The rhs (right hand side) of lines 1 and 2 are of type `PythonObject`. PythonObject is a Mojo type that can store Python objects of any class. 
(The _ = are needed to avoid the warning: 'PythonObject' value is unused)
The above code is equivalent to the following when used in a Jupyter notebook running Mojo (see § 2):

```mojo
%%python
x = 5 + 10
print(x)
```

In the Mojo playground, using `%%python` at the top of a cell will run code through Python instead of Mojo.  
Python objects are all allocated on the heap, so x is a heap reference.

All the Python keywords can be accessed by importing `builtins`:
```mojo
let py = Python.import_module("builtins")
py.print("this uses the python print keyword")
```

>Note: The py.print statements work alright, but they generate a warning: "'PythonObject' value is unused", to let this disappear, prefix it with _ =.

Now we can use the `type` built-in from Python to see what the dynamic type of x is:
```mojo
py.print(py.type(x))  # => <class 'int'>
```

The address where the value of x is stored on the heap is given by the Python built-in `id`. This address itself is stored on the stack. (?? schema)

```mojo
py.print(py.id(x))   # =>  139787831339296
```

When Mojo uses a PythonObject, accessing the value actually uses the address in the stack to lookup the data on the heap, even for a simple integer. The heap object contains a reference count, and the runtime will free the object's memory when the count reaches 0. 
A Python object also can change its type dynamically (provided you declare it with var in a fn), which is also stored in the heap object:
```mojo
x = "mojo"            
print(x)              # => mojo
```

All this makes programming easier, but comes with a performance cost!

>Note: You could also just use a def main():, then raises and var x are not needed, and you won't get any warnings!

The equivalent Mojo code is:

See `equivalent.mojo`:
```mojo
fn main():
    let x = 5 + 10
    print(x)    # => 15
```

We've just unlocked our first Mojo optimization! Instead of looking up an object on the heap via an address, x is now just a value on the stack with 64 bits that can be passed through registers.

Here is a simple example of using `matplotlib`:
(If you first need to install this package, use the command: `sudo apt-get install python3-matplotlib`)
See `simple_matplotlib.mojo`:
```mojo
from python import Python

fn main() raises:
    let plt = Python.import_module("matplotlib.pyplot")

    let x = [1, 2, 3, 4]
    let y = [30, 20, 50, 60]
    _ = plt.plot(x, y)
    _ = plt.show()
```
See image of plot: simple_plot.png

## 8.2 Running Python code in the interpreter mode or in the Mojo mode
The Mojo mode has numerous performance implications:
* There is no overhead associated with compiling to bytecode and running through an interpreter
* All the expensive allocation, garbage collection, and indirection is no longer required
* The compiler can do huge optimizations when it knows what the numeric type is
* The value can be passed straight into registers for mathematical operations
* The data can now be packed into a vector for huge performance gains

So there is a great difference between running Python inside Mojo (through a Python object or %%python), and running Mojo code, although the Mojo code may be exactly the same as the Python code.  

In the 1st case, the Python code is interpreted at compile-time through a CPython interpreter, which communicates with the Mojo compiler.
In the 2nd case, the code is compiled to native code, and then run, which is obviously a lot faster.


## 8.3 Working with Python modules
As already indicated in § 3.6.2, here is how you import a Python module, in this case numpy. After importing it, we exercise a few basic functions from numpy, as if writing in Python, see lines 3-4. All variables created (ar, arr, array) are PythonObjects.

See `numpy.mojo`:
```mojo
from python import Python                    # 1

fn main() raises:
    let np = Python.import_module("numpy")   # 2

    let array = np.array([1, 2, 3])          # 3
    print(array)  # => [1  2  3]

    var arr = np.ndarray([5])        
    print(arr)  
    # => [4.67092872e-310 0.00000000e+000 0.00000000e+000 4.67150278e-310 2.37151510e-322]
    arr = "this will work fine"  # Python is loosely typed, so:
    print(arr)                   # => this will work fine

    let ar = np.arange(15).reshape(3, 5)
    print(ar)
    # =>
    # [[ 0  1  2  3  4]
    # [ 5  6  7  8  9]
    # [10 11 12 13 14]]
    print(ar.shape)                          # 4
    # => (3, 5)
```

You can import any other Python module in a similar manner. Keep in mind that you must import the whole Python module.  You cannot import individual members (such as a single Python class or function) directly - you must import the whole Python module and then access members through the variable name you gave the module.

Importing a module could give an error when that module is not locally installed. That's why we must indicate that fn main() could raise an error with: `fn main() raises`.  
A better way to handle this is to use a try/except construct, as in the following program, where we assume the Python pandas module is not locally installed.

See `importing_error.mojo`:
```mojo
from python import Python

fn main():
    try:
        let pd = Python.import_module("pandas")
        print(pd.DataFrame([1,2,3,4,5]))
    except ImportError:
        print('error importing pandas module')
    # => error importing pandas module
```

### 8.3.2 How to do an HTTP-request from Python?
(as an exercise??)

See `http_request_from_py.mojo`:
```py
from python import Python

fn main() raises:
    let requests = Python.import_module("requests")
    let response = requests.get("https://www.standaard.be/")
    print(response.text)

# =>
# <!doctype html>
# <html class="m_no-js oneplatform_renderFragmentServerSide_mostread conv_enableSegmentedOffer openam temp_liveFeedOnArticleDetail conv_activationwall oneplatform_renderFragmentServerSide_articlelist conv_subscriptionWall enableThirdPartySocialShareService video_enableSpark web_temp_enableWetterKontorIntegration temp_useScribbleLiveApi oneplatform_renderFragmentServerSide_particles paywall_porous_isEnabled temp_enableAddressServiceApi oneplatform_renderFragmentServerSide_articledetail temp_web_enableSeparateDfpScript video_enableAutoplay paywall_metering_v2 web_temp_enableNewGdpr temp_sportMappingViaDb conv_useConversionFlows oneplatform_renderFragmentServerSide_articlegrid oneplatform_fragment_enableMenus aboshop_pormax oneplatform_renderFragmentServerSide_singlearticle temp_useAMConfiguration oneplatform_renderFragmentServerSide_search accountConsent_showPopups conv_loginwall conv_passwordreset com_pushnotificationsOptinboxEnabled temp_newHeader enableReadLater paywall_bypassPaywallForBots PERF_DisableArticleUpdateCounters accountinfo_not_getidentity " dir="ltr" lang="nl-BE">
# <head>
#     <meta charset="utf-8">
```

### 8.3.3 Understanding the interaction between Python and Mojo
This is illustrated in the following program, the comments show you when you are in Python land, and when in Mojo land!

See `interaction_python_mojo.mojo`:
```mojo
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
```

We start with importing references to the Python environment in line 0. The Python reference is generally used to import Python modules. These must allready be installed on the machine, the import command doesn't do any install. PythonObject is a Mojo type to store any object of a Python class  (see: https://docs.modular.com/mojo/stdlib/python/object.html#init__).  
In line 1 in main(), we call the Mojo function `numpy_array_from_mojo`, which returns a PythonObject. In line 3, np is a PythonObject, as always when you import a Python module.
Line 4 declares a PythonObject x explicitly. It is initialized a list class from an empty list literal. Nota that [] is a Mojo value of type ListLiteral (see https://docs.modular.com/mojo/stdlib/python/object.html#init__).  
range_size in line 5 is a Mojo Int value, as well as i in line 6. 
In line 6,  i is automatically converted to Python object by method __init__ of PythonObject.  
In line 7, the `append` is a Python method of the list class, because x is a PythonObject!
(append is in Python land and Mojo can call it!). Note that append is not a method of PythonObject  (https://docs.modular.com/mojo/stdlib/python/object.html). It lives in Python land and Mojo is able to find it inside the python object.  
This is why it is possible to import any created Python file, as in:
```mojo
var my_python_file = Python.import_module("my_python_file_name")
my_python_file.my_function([1,2,3])
```
In line 8, a numpy array is created with the list x. This is converted to a suitable value, and the cos value is calculated. So the method returns an Python array of cosine values, which is assigned to results in line 1, and passed as argument to plot_from_mojo in line 2.  
As we see in line 9, plot_from_mojo is a Mojo function that takes a PythonObject. `results` "travel" trough Mojo functions,as a PythonObject, but can also be passed to Python land functions, as a PythonObject.  
In line 10 we import matplotlib (which must be installed allready).  
In line 11, the values (or results) comes from numpy. The Python object class is ndarray: `print(values.__class__.__name__)` # => ndarray. The matplotlib Python functions plot (line 11) and show (line 12) are then used to display the [plot](see ??)

*An example using SIMD* (perhaps as an exercise?)
See `py_mojo_simd.mojo`:
```mojo
from python import Python, PythonObject
from math import math
from time import now

struct np_loader:
    var lib: PythonObject
    var loaded: Bool

    fn __init__(inout self):
        try:
            self.lib = Python.import_module("numpy")
            self.loaded = True
        except e:
            self.loaded = False

    fn __getitem__(inout self, key:StringLiteral) raises -> PythonObject:
        return self.lib.__getattr__(key)

fn main() raises:
    var np = np_loader()                                        # 1 
    if np.loaded:                                               # 2
        let python_result = np["linspace"](0, 255, 256)         # 3
        print(python_result) 
        # =>
        # [  0.   1.   2.   3.   4.   5.   6.   7.   8.   9.  10.  11.  12.  13.
        # 14.  15.  16.  17.  ...   253. 254. 255.]
        var simd_mojo_array = SIMD[DType.float64, 256]()        # 4
        let pi = np["pi"].to_float64()                          # 5
    
        let size: Int = python_result.size.to_float64().to_int()   # 6 
        for x in range(size):                                      # 7
            simd_mojo_array[x] = python_result[x].to_float64()    

        simd_mojo_array = math.cos(simd_mojo_array*(pi*2.0/256.0))  # 8   
        print(simd_mojo_array)    

# =>
# [1.0, 0.99969881869620425, 0.99879545620517241, 0.99729045667869021, 
# 0.99518472667219693, 0.99247953459870997, 0.98917650996478101, 
# 0.98527764238894122, ...,  0.99879545620517241, 0.99969881869620425]
```
 
The call to np_loader in line 1 gets numpy from the Python local environment, by calling its __init__ method. This does exception handling (see § 5.4) because there could be an error (e.g. when numpy is not installed locally). A Bool value loaded is set to True when everything is ok; this is tested in line 2.  
In line 3, we see a new way to interact with Python:  
np["linspace"] is called, through the __getitem__ method with "linspace" as key. The same happens in line 5 with key "pi". Python returns PythonObjects, so therefore they sometimes require conversion to Mojo types in order to use some functions, that's why we use to_float64() here.
Line 4 constructs a Mojo SIMD array of size 256, which will perform the calculation a lot faster than numpy. Same remark for line 6: convert arr size to Mojo Int.  
In the loop starting in line 7, we fill the SIMD Mojo array with the Python values: we convert from Python float objects to Mojo float values.  
Then in line 8, we apply the Mojo cos function to the SIMD array.

**Exercise**
Add the code to plot the result.
(?? error: invalid call to 'plot_from_mojo': argument #0 cannot be converted from 'SIMD[f64, 256]' to 'PythonObject')


## 8.4 Importing local Python modules
This works just like in the preceding §. In the following example, the local Python module `simple_interop.py` is imported through Mojo in line 1. Then in line 2, its `test_interop_func` is called:

See `hello_interop.mojo`:
```mojo
from python import Python
    
def main():
    try:
        Python.add_to_path(".")
        let test_module = Python.import_module("simple_interop")  # 1
        test_module.test_interop_func()                           # 2
    except e:
        print(e.value)
        print("could not find module simple_interop")
```

Because this could potentially raise an exception, the call to Python is enclosed in a `try: except:` statement.  
The Python code imports numpy, printing a "hello" message and then a numpy array:

See ``simple_interop.py`:
```mojo
import importlib
import sys
import subprocess

if not importlib.find_loader("numpy"):
    print("Numpy not found, installing...")
    subprocess.check_call([sys.executable, "-m", "pip", "install", "numpy"])

import numpy as np
from timeit import timeit

def test_interop_func():
    print("Hello from Python!")   
    # => Hello from Python!
    a = np.array([1, 2, 3])
    print("I can even print a numpy array: ", a)  
    # => I can even print a numpy array:  [1 2 3]

if __name__ == "__main__":
    print(timeit(lambda: test_interop_func(), number=1))
```

If the .py file is somewhere in a different folder, instead of: `Python.add_to_path(".")` do `Python.add_to_path("path/to/module")`

A subfolder `__pycache__` is created which contains the byte-compiled versions (.pyc) of the Python code.  
For another example, see `matmul.mojo` and `pymatmul.py` with output:  
```
$ mojo matmul.mojo
Throughput of a 128x128 matrix multiplication in Python:
0.004103122307077609 GFLOP/s
Throughput of a 512x512 matrix multiplication in Mojo using a naive algorithm:
7.2246632712722363 GFLOP/s <> 1760 x speedup over Python
Throughput of a 512x512 matrix multiplication in Mojo using vectorization:
35.700177799044923 GFLOP/s <> 8700 x speedup over Python
Throughput of a 512x512 matrix multiplication in Mojo using the stdlib `vectorize`:
35.407991678374337 GFLOP/s <> 8629 x speedup over Python
Throughput of a 512x512 {vectorized + parallelized} matrix multiplication in Mojo:
132.4017061977911 GFLOP/s <> 32268 x speedup over Python
Throughput of a 512x512 {tiled + vectorized + parallelized} matrix multiplication in Mojo:
112.45366967788205 GFLOP/s <> 27406 x speedup over Python
Throughput of a 512x512 {tiled + unrolled + vectorized + parallelized} matrix multiplication in Mojo:
124.27026601620115 GFLOP/s <> 30286 x speedup over Python
```

## 8.5 Mojo types in Python
Mojo primitive types (bools, integers, floats, strings, lists and tuples (see § 9) implicitly convert into Python objects. 

See `mojo_types.mojo`: (works only in a cell in a Jupyter notebook)
```mojo
%%python
def type_printer(my_list, my_tuple, my_int, my_string, my_float):
    print(type(my_list))
    print(type(my_tuple))
    print(type(my_int))
    print(type(my_string))
    print(type(my_float))

type_printer([0, 3], (False, True), 4, "orange", 3.4)
```

**Exercises**
1- Use the Python interpreter to calculate 2 to the power of 8 in a PythonObject and print it
(see `exerc8.1.mojo`)
2- Using the Python math module, return pi to Mojo and print it
(see `exerc8.2.mojo`)
3- Use the input() function from the Python builtins module to get user input, and then display it.
(see `get_input.mojo`)



