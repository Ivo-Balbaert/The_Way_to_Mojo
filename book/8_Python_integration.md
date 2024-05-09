# 8 Python integration
Mojo's long-term goal is to become a superset of Python. It allows us already to leverage the huge Python ecosystem of libraries and tools.
You can use Python for what it's good at, especially graph plotting and GUIs and for things that do not yet exist or are more difficult to rewrite in Mojo.
That way, a Python project can be gradually migrated to Mojo.

Mojo aims to vastly improve the experience of writing a performant library, so you don't need to write C/C++ underneath Python for performance and hardware optimizations.

Calling Mojo from Python is not yet ready (2024 May). (The common Python dev won't be excited by Mojo until they start getting libraries that are much more performant than what they're used to, with code they can actually step into and understand).

The more that Python wins, the more that Mojo wins. And a bigger audience for Mojo will also grow the Python community, because they will be first class citizens to the fastest libraries in the world. It's a **symbiotic relationship**.

There are some common builtin functions ( print , len , range , slice , …) and the syntax is largely compatible (imports, indexing, slicing, loops, function def, with contexts, try/except, async/await, even struct definition with dunder methods, …)

Code that uses Python in a Jupyter notebook must be preceded with `%%python`: 
```py
%%python
print("The answer is", 42)
```

At this moment, the equivalent Mojo code in a file is:
```py
fn main():
    print("The answer is", 42)
```

In a Jupyter notebook, using `%%python` at the top of a cell will run code through Python instead of Mojo.  
Python objects are all allocated on the heap.


## 8.1 Comparing the same program in Python and Mojo
Here is a Python program to add two integers:
See `adding.py`:
```py
def add(x, y):
    return x + y

z = add(3, 5)
print(z) # => 8
```

Here is the corresponding Mojo program without types:
See `adding_likepy.mojo`:
```py
def add(x, y):
    return x + y

def main():
    z = add(3, 5)
    print(z) # => 8
```

This is identical, apart from def main()!

And here is the corresponding Mojo program with types:
See `adding.mojo`:
```py
fn add(x: Int, y: Int) -> Int:
    return x + y

fn main():
    var z = add(3, 5)
    print(z) # => 8
```


Let's do a compute time comparison over 1_000_000 additions.
This takes Python (see adding_timing.py) 63848700.000562534  nanoseconds:
```py
import time

def add(x, y):
    return x + y

start = time.perf_counter()

for i in range(1_000_000):
    z = add(i, i + 1)

end = time.perf_counter()
# After 1000000 rounds:
# perf_counter() function always returns the float value of time in seconds
# https://www.geeksforgeeks.org/time-perf_counter-function-in-python/
# so we have to multiply it by 1_000_000_000 to get the elapsed time in nanoseconds
print("It took Python", (end - start) * 1_000_000_000, " nanoseconds")
# => It took Python 63848700.000562534  nanoseconds
```

Let's try the nearly identical Mojo version (see `adding_likepy_timing.mojo):
```py
from time import now

def add(x, y):
    return x + y

def main():
    z = 0
    start = now()
    for i in range(1_000_000):
        z = int(add(i, i + 1)) # this conversion was needed
    end = now()
    
    print("It took Mojo", end - start , " nanoseconds")
    # => It took Mojo 37  nanoseconds
```

This version takes 37 nanoseconds, so almost identical code is 1_725_640 faster than Python!

The fully typed `adding_timing.mojo` takes some 27 nanoseconds, so is 2_364_767 times faster than Python. 

```py
from time import now

fn add(x: Int, y: Int) -> Int:
    return x + y

fn main():
    var z: Int
    var start = now()
    for i in range(1_000_000):
        z = add(i, i + 1)
    var end = now()
    
    print("It took Mojo", end - start , " nanoseconds")
# => It took Mojo 27  nanoseconds
# This is 2_364_767 times faster than Python!

# now() Returns the current monotonic time time in nanoseconds
# https://docs.modular.com/mojo/stdlib/time/time.html
```

In this trivial example, adding types,etc. doesn't add much extra performance, because Mojo is very good at type inference and optimizations.

*How can we explain this huge performance difference?*
First, Mojo always uses SIMD operations for math operations, like + here (see § 4.4)
Python completely works with references: z and i are reference to objects on the heap. In Mojo, z and i are just values on the stack with 64 bits that can be passed through registers. We don't need to look up an object on the heap via an address. 

>Note: The speedup in this example is extraordinarily huge (perhaps other factors play a role here??). The performance difference between Mojo and Python in more realistic programs usually lies between 1 and 3 orders of magnitude (10s - 1000s).

## 8.2 Running Python code in Mojo
>Note: If you're having trouble executing the following programs, it probably means Mojo can't find Python on your machine. Refer to § 8.6

To execute a Python expression, you can use the `evaluate` method:  

See `python1.mojo`:
```py
from python import Python

fn main() raises:
    var w: Int = 42
    var x = Python.evaluate('5 + 10')          # 1 - this is of type `PythonObject`
    print(x)   # => 15

    var py = Python() # type `PythonObject`
    var py_string = py.evaluate("'This string was built' + ' inside of python'")
    print(py_string)  # => This string was built inside of python
 
    var pybt = Python.import_module("builtins") # 2
    _ = pybt.print("this uses the python print function") # => this uses the python print function
    _ = py.print("The answer is", w) # => The answer is 42
    _ = pybt.print(pybt.type(x))  # => <class 'int'>
    _ = pybt.print(pybt.id(x))    # => 139787831339296

    print(pybt.type([0, 3]))            # 3 - uses the Mojo print function
    print(pybt.type((False, True)))
    print(pybt.type(4))
    print(pybt.type("orange"))
    print(pybt.type(3.4))
# =>
# <class 'list'>
# <class 'tuple'>
# <class 'int'>
# <class 'str'>
# <class 'float'>
```

If you leave out the keyword `raises`, you get the error:  
```
cannot call function that may raise in a context that cannot raise
python1.mojo(4, 28): try surrounding the call in a 'try' block
python1.mojo(3, 1): or mark surrounding function as 'raises'
```

Apparently, Mojo warns you that `Python.evaluate` could raise an error, that Mojo should catch.

The rhs (right hand side) of lines 1 and 2 are of type `PythonObject`. PythonObject is a Mojo type that can store Python objects of any class (see: https://docs.modular.com/mojo/stdlib/python/object.html#init__).  
(The _ = are needed to avoid the warning: 'PythonObject' value is unused)

All the Python keywords can be accessed by importing `builtins`:
```py
var pybt = Python.import_module("builtins")
pybt.print("this uses the python print function")
```

Now we can use the `type` built-in from Python to see what the dynamic type of x is:
```py
pybt.print(pybt.type(x))  # => <class 'int'>
```

The address where the value of x is stored on the heap is given by the Python built-in function `id`. This address itself is stored on the stack. (?? schema)

```py
pybt.print(pybt.id(x))   # =>  139787831339296
```

In line 3 and following, we see that Mojo primitive types (bools, integers, floats, strings, lists and tuples (see § 9)) implicitly convert into Python objects. 

When Mojo uses a PythonObject, accessing the value actually uses the address in the stack to lookup the data on the heap, even for a simple integer. The heap object contains a reference count, and the runtime will free the object's memory when the count reaches 0. 
A Python object also can change its type dynamically.
All this makes programming easier, but comes with a performance cost!

>Note that the output from the Python print function comes after the Mojo print output!


## 8.3 Running Python code in the interpreter mode or in the Mojo mode
So we've seen that there is a great difference between running Python inside Mojo (through a Python object or %%python), and running Mojo code, although the Mojo code may be exactly the same as the Python code.  

In the 1st case, the Python code is interpreted at compile-time through a CPython interpreter, which communicates with the Mojo compiler.
In the 2nd case, the code is compiled to native code, and then run, which is obviously a lot faster.

The Mojo mode has numerous performance implications:
* There is no overhead associated with compiling to bytecode and running through an interpreter
* All the expensive allocation, garbage collection, and indirection is no longer required
* The compiler can do huge optimizations when it knows what the numeric type is
* The value can be passed straight into registers for mathematical operations
* The data can now be packed into a vector for huge performance gains


## 8.4 Working with Python 
To work with Python we start with importing references to the Python environment, like so:  
`from python import Python, PythonObject`

* the Python reference is generally used to import Python modules  (see § 8.4.1).
* in a lot of cases you will also have to work with Python objects (see § 8.4.2).

### 8.4.1 Importing Python modules
Here we import Python modules using `Python.import_module`, and then start using Python functionality, as we already did in § 8.2. But let us look first to make our code solid so that it not breaks when the specified module doesn't exist on the system.

#### 8.4.1.1 Testing that the Python module is available
We must indicate that fn main() could raise an error with: `fn main() raises`, because importing a module could give an error when that module is not locally installed.  
A better way to handle this is to use a try/except construct, as in the following program, where we assume the Python pandas module is not locally installed.

See `importing_error.mojo`:
```py
from python import Python

fn main():
    try:
        var pd = Python.import_module("pandas")
        print(pd.DataFrame([1,2,3,4,5]))
    except ImportError:
        print('error importing pandas module')
    # => error importing pandas module
```

Another way is illustrated in § 8.4.2.4, where a Python module is loaded as part of the initialization of a struct.

#### 8.4.1.2 Using numpy
After importing numpy we exercise a few basic of its basic functions from numpy, as if we were writing in Python, see lines 3-4. All variables created (ar, arr, array) are PythonObjects.

See `numpy.mojo`:
```py
from python import Python                  # 1

fn main() raises:
    var np = Python.import_module("numpy")   # 2

    var array = np.array([1, 2, 3])          # 3
    print(array)  # => [1  2  3]

    var arr = np.ndarray([5])        
    print(arr)  
    # => [4.67092872e-310 0.00000000e+000 0.00000000e+000 4.67150278e-310 2.37151510e-322]
    arr = "this will work fine"  # Python is loosely typed, so:
    print(arr)                   # => this will work fine

    var ar = np.arange(15).reshape(3, 5)
    print(ar)
    # =>
    # [[ 0  1  2  3  4]
    # [ 5  6  7  8  9]
    # [10 11 12 13 14]]
    print(ar.shape)                          # 4
    # => (3, 5)
```

You can import any other locally installed Python module in a similar manner. Keep in mind that you must import the whole Python module. You cannot import individual members (such as a single Python class or function) directly - you must import the whole Python module and then access members through the variable name you gave the module. 

#### 8.4.1.3 Making plots with matplotlib
Here is a simple graphical example of using `matplotlib`:
(If you first need to install this package, use the command: `sudo apt-get install python3-matplotlib`)
See `simple_matplotlib.mojo`:
```py
from python import Python

fn main() raises:
    var plt = Python.import_module("matplotlib.pyplot")

    var x = [1, 2, 3, 4]
    var y = [30, 20, 50, 60]
    _ = plt.plot(x, y)
    _ = plt.show()
```
See image of plot: simple_plot.png

#### 8.4.1.4 How to do an HTTP-request from Python
See `http_request_from_py.mojo`:
```py
from python import Python

fn main() raises:
    var requests = Python.import_module("requests")
    var response = requests.get("https://www.standaard.be/")
    print(response.text)

# =>
# <!doctype html>
# <html class="m_no-js oneplatform_renderFragmentServerSide_mostread conv_enableSegmentedOffer openam temp_liveFeedOnArticleDetail conv_activationwall oneplatform_renderFragmentServerSide_articlelist conv_subscriptionWall enableThirdPartySocialShareService video_enableSpark web_temp_enableWetterKontorIntegration temp_useScribbleLiveApi oneplatform_renderFragmentServerSide_particles paywall_porous_isEnabled temp_enableAddressServiceApi oneplatform_renderFragmentServerSide_articledetail temp_web_enableSeparateDfpScript video_enableAutoplay paywall_metering_v2 web_temp_enableNewGdpr temp_sportMappingViaDb conv_useConversionFlows oneplatform_renderFragmentServerSide_articlegrid oneplatform_fragment_enableMenus aboshop_pormax oneplatform_renderFragmentServerSide_singlearticle temp_useAMConfiguration oneplatform_renderFragmentServerSide_search accountConsent_showPopups conv_loginwall conv_passwordreset com_pushnotificationsOptinboxEnabled temp_newHeader enableReadLater paywall_bypassPaywallForBots PERF_DisableArticleUpdateCounters accountinfo_not_getidentity " dir="ltr" lang="nl-BE">
# <head>
#     <meta charset="utf-8">
```

#### 8.4.1.5  ...


### 8.4.2 Working with Python objects
If you can't get what you want with Python modules, perhaps you can reach your goal by purely manipulating Pythonobjects! Beware that this will not be good for performance though.
You can initialize a Python object in several ways:  
```py 
    alias py = PythonObject
    var py = PythonObject([]) 
    var py = Python()  
```

#### 8.4.2.1 How to work with big integers in Mojo
Here is a simple trick that allows you to work with big integers with the help of Python.  A big integer type is emulated by using a PythonObject.

See `intInt.mojo`:
```py
from python import PythonObject

alias int = PythonObject


fn main() raises:
    var x: int = 2
    # Python `int` does not overflow:
    print(x**100)  # => 1267650600228229401496703205376
    # Mojo `Int` overflows:
    print(2**100)  # => 0
```

#### 8.4.2.2 Using Pythonobjects for floats and strings
See `pythonobject.mojo`:
```py
from python import Python

alias str = PythonObject
alias float = PythonObject


fn main() raises:
    var f: float = 0.6       # f is a Python `float` object
    print(f.hex())  # => 0x1.3333333333333p-1
 
    var s1: str = "xxbaaa"   # s1 is a Python `str` object
    print(s1.upper())  # => XXBAAA
```

#### 8.4.2.3 Using numpy and matplotlib together
Here we use these two Python modules, and we use a PythonObject (see line 4) to create our data, which we transform through a few numpy functions and then pass to matplotlib for our graph.
The comments below show you when you are in Python land, and when in Mojo land!

See `interaction_python_mojo.mojo`:
```py
from python import Python, PythonObject    


fn plot_from_mojo(values: PythonObject) raises:   # 9
    print(values.__class__.__name__)  # => ndarray
    var plt = Python.import_module("matplotlib.pyplot")   # 10  
    _ = plt.plot(values)                          # 11              
    _ = plt.show()                                # 12

fn numpy_array_from_mojo() raises -> PythonObject:
    var np = Python.import_module("numpy")   # 3    

    var x = PythonObject([])         # 4           
    var range_size: Int = 256        # 5           
    for i in range(range_size):      # 6          
        _ = x.append(i)              # 7 
    print(x)   # => [0, 1, 2, 3, 4, ..., 253, 254, 255]

    return np.cos(np.array(x)*np.pi*2.0/256.0)  # 8 

def main():            
    var results = numpy_array_from_mojo()   # 1    
    plot_from_mojo(results)                 # 2    
```

In line 1 in main(), we call the Mojo function `numpy_array_from_mojo`, which returns a PythonObject. In line 3, np is a PythonObject, as always when you import a Python module.
Line 4 declares a PythonObject x explicitly. It is initialized as a list class from an empty list literal. Nota that [] is a Mojo value of type ListLiteral (see https://docs.modular.com/mojo/stdlib/python/object.html#init__).  
range_size in line 5 is a Mojo Int value, as well as i in line 6. 
In line 6,  i is automatically converted to Python object by method __init__ of PythonObject.  
In line 7, the `append` is a Python method of the list class, because x is a PythonObject!
(append is in Python land and Mojo can call it!). Note that append is not a method of PythonObject  (https://docs.modular.com/mojo/stdlib/python/object.html). It lives in Python land and Mojo is able to find it inside the Python object.  

In line 8, a numpy array is created with the list x. This is converted to a suitable value, and the cos value is calculated. So the method returns a Python array of cosine values, which is assigned to results in line 1, and then passed as argument to plot_from_mojo in line 2.  
As we see in line 9, plot_from_mojo is a Mojo function that takes a PythonObject. `results` "travels" trough Mojo functions, as a PythonObject, but can also be passed to Python-land functions, as a PythonObject.  
In line 10 we import matplotlib. In line 11, the values (or results) come from numpy. The Python object class is ndarray: `print(values.__class__.__name__)` # => ndarray. The matplotlib Python functions plot (line 11) and show (line 12) are then used to display the [plot](see ??)


#### 8.4.2.4 Combining numpy and SIMD
See `py_mojo_simd.mojo`:
```py
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

    fn __getitem__(inout self, key: StringLiteral) raises -> PythonObject:
        return self.lib.__getattr__(key)

fn main() raises:
    var np = np_loader()                                        # 1 
    if np.loaded:                                               # 2
        var python_result = np["linspace"](0, 255, 256)         # 3
        print(python_result) 
        # =>
        # [  0.   1.   2.   3.   4.   5.   6.   7.   8.   9.  10.  11.  12.  13.
        # 14.  15.  16.  17.  ...   253. 254. 255.]
        var simd_mojo_array = SIMD[DType.float64, 256]()        # 4
        var pi = np["pi"].to_float64()                          # 5
    
        var size: Int = int(python_result.size)      # 6 
        for i in range(size):                                     # 7
            simd_mojo_array[i] = python_result[i].to_float64()    

        simd_mojo_array = math.cos(simd_mojo_array*(pi*2.0/256.0))  # 8   
        print(simd_mojo_array)   

        var x = PythonObject([])                              # 9   
        var range_size: Int = 256                   
        for i in range(range_size):                
            _ = x.append(simd_mojo_array[i])    

        var plt = Python.import_module("matplotlib.pyplot")   # 10  
        _ = plt.plot(x)                                       # 11              
        _ = plt.show()                                        # 12   

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
Add the code to plot the result: see `py_mojo_simd.mojo`



## 8.5 Importing local Python modules
This works just like in the preceding sections for existing Python modules. In the following example, the local Python module `simple_interop.py` is imported through Mojo in line 1. Then in line 2, its `test_interop_func` is called:

See `hello_interop.mojo`:
```py
from python import Python
    
def main():
    try:
        Python.add_to_path(".")      # import from local directory
        var test_module = Python.import_module("simple_interop")  # 1
        test_module.test_interop_func()                           # 2
    except e:
        print(e)  # => No module named 'simple_interop'
```

Because this could potentially raise an exception, the call to Python is enclosed in a `try: except:` statement.  
The Python code imports numpy, printing a "hello" message and then a numpy array:

See ``simple_interop.py`:
```py
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

If the .py file is somewhere in a different folder, instead of: `Python.add_to_path(".")` do `Python.add_to_path("path/to/module")`. Both absolute and relative paths work with add_to_path().

A subfolder `__pycache__` is created which contains the byte-compiled versions (.pyc) of the Python code.  

(For another example that uses the same techniques, see `matmul.mojo` and `pymatmul.py` in § 20.3) 

# 8.6 Installing Python for interaction with Mojo
Mojo not finding an appropriate Python installation should have been signaled when Mojo was installed. At that moment,Mojo tries to locate the CPython shared library using the find_libpython module. 
Possible failure causes are:
* Python is not installed
* The installed Python version is not supported by the Mojo SDK
* The installer can't find a shared library version of the CPython interpreter (for example, a .so or .dylib file). Some Python distributions don't include shared libraries, which prevents Mojo from embedding the interpreter.

The solution is to install a compatible version of Python that includes shared libraries.
The Mojo docs describe setting up [a Python environment with Conda](https://docs.modular.com/mojo/manual/python/#set-up-a-python-environment-with-conda). This [blog post](https://www.modular.com/blog/using-mojo-with-python) elaborates on that subject. 

>Note: you can see which Python version is used in the modular.cfg file (see § 2.9), section [mojo] in `python-lib`.
This value can be modified if necessary.









**Exercises**
1- Use the Python interpreter to calculate 2 to the power of 8 in a PythonObject and print it
(see `exerc8.1.mojo`)
2- Using the Python math module, return pi to Mojo and print it
(see `exerc8.2.mojo`)
3- Use the input() function from the Python builtins module to get user input, and then display it.
(see `get_input.mojo`)

