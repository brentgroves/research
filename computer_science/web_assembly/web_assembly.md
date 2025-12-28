# **[Webassembly Tutorial](https://marcoselvatici.github.io/WASM_tutorial/)**

**[code](../../../../volumes/wasm)**

Introduction
Webassembly (WASM) is an innovative low-level language that can run on all modern browsers. As the name suggests, this is an assembly-like language that have a very compact binary format (thus suitable to be loaded on web pages) and can run with near-native performance.
Thanks to this technology, there is now the possibility to compile high-level languages and run them on the browser. Currently the only languages that can be compiled to WASM binaries are C and C++, but in future the list will probably grow a lot.

It is important to point out that WASM is not going to cut off JavaScript, you will still need it for several reasons that will be explained later on.

In this tutorial, you will learn the basics concepts behind this technology and then you will be ready to create a complete Webassembly-based WebApp!
Furthermore, I am going to guide you through all the concepts by using examples inspired to what I learned creating an online WASM-based file compressor.

Key concepts
There are a few key concepts that we need to know about WASM:

- **Module:** it is the compiled binary code (in other words, the .wasm file).
- **Memory:** a JavaScript typed array that represents the memory for your program.
- **Table:** an array (separated from the memory) that contains the references to the function that you use.
- **Instance:** it is the union of a Module, a Memory and a Table plus some other values that needs to be stored.
Don't worry if you don't get everything at this stage, things will start to make sense once you see them working.

## WASM workflow

If you are familiar with compiled languages, you probably know the steps that your code go through before being executed. Just as a reminder:

![i](https://marcoselvatici.github.io/WASM_tutorial/ref/compile.gif)

If you worked with C/C++, you probably used compilers like gcc or similar. In order to get a Webassembly binary file, we will need some other special compilers. There are more than one available, but currently the best one is Emscripten (and it is open source!).
Differently from the "normal" assembly languages, Webassembly is not CPU specific and therefore can run on multiple platforms, from embedded systems like your phone to the CPU of your computer.

Once we compile our C/C++ code with Emscripten, we obtain a proper WASM file that can run on the browser, pretty straightforward right?
Actually, there are a few more details to consider, but we will cover them step by step.

Briefly, the steps to get your WASM WebApp working are:

1. Compile C/C++ code with Emscripten, to obtain a WASM binary.
2. Bind your WASM binary to your page using a JavaScript "glue code".
3. Run your app and let the browser to instantiate your WASM module, the memory and the table of references. Once that is done, your WebApp is fully operative.

## Browser environment

It is really important to understand that WASM binaries are run in the same **[sandbox](https://www.howtogeek.com/169139/sandboxes-explained-how-theyre-already-protecting-you-and-how-to-sandbox-any-program/)** as JavaScript (in a nutshell, a sandbox is an isolated environment where your code is executed for security reasons).

![i](https://marcoselvatici.github.io/WASM_tutorial/ref/sandbox.gif)

Therefore, you will be able to access only the data that are also accessible with JavaScript. This means, for example, that you will not be able to access a file like this (unless you preload it at compile time):

```c
// "standard" C code to open a file
FILE *fp;
fp = fopen("/path/to/file/file.txt", "r");
```

Instead, you will have to read them via JavaScript and then use them with WASM, but we will return on this later.
You will furthermore have some limitations in the memory you can dynamically and statically allocate, depending on the browser you are using (but these are usually pretty big, so it is unlikely that you will suffer from that).

## Install Emscripten

First of all, let's install the WASM compiler, Emscripten. We will focus on how to install it for Linux, but you can find documentation for other OSes here.

First of all you need to have a working compiler toolchain installed (the set of tools that allows you to compile the code and get an executable) since we will build the software from the source code. Open a terminal and type:

```bash
# Update the package lists
sudo apt-get update

# Install *gcc* (and related dependencies)
sudo apt-get install build-essential

# Install cmake
sudo apt-get install cmake
```

You also need to install:
python 2.7
node.js

```bash
# Install Python

sudo apt-get install python2.7

# Install node.js

sudo apt-get install nodejs
```

Great! Now we have all the prerequisites to install the Emscripten Software Development Kit (emsdk). Just follow these steps:

Don't do this.

- Download and unzip the Software Development Kit (SDK) package to the directory of your choice. Here is the the **[link](https://s3.amazonaws.com/mozilla-games/emscripten/releases/emsdk-portable.tar.gz)**.
Open a terminal inside the folder emsdk-portable you already unzipped.
Now run the emsdk commands to obtain the latest tools from Github and set them as active:

Do this instead

**[emscripten_install](./emscripten/emscripten_install.md)**

## Your first WASM webapp

Once Emscripten is installed, we are ready to create our first WASM app!

1. Create a folder wherever you want that contains a C file with this simple code:

      ```bash
      cd ~/src/repsys/volumes/wasm/first
      ```

      Create main.c

      ```c
      #include <stdio.h>

      int main(){
          printf("Hello world!\n");
          return 0;
      }
      ```

2. With your previous terminal, move in to the new directory and compile the C code to WASM using Emscripten

    `emcc hello.c -o hello.html -s WASM=1`

Explanation:

- emcc is the program you call to compile your C code (similar to call gcc or g++ when you compile your C/C++ files "normally").
- -o hello.html tells the compiler to create the hello.html file so you can visualize the results of the WASM code.
- -s WASM=1 tells the compiler to create a separated .wasm file. You can omit this and the everything will work the same, just your hello.js (see next point) will contain also the WASM binary.

Note that since this is the first time you use the stdio.h library, Emscripten needs to compile it to WASM binary before it can actually compile your code. This may take some moments.

Now you should be able to see other three files in the same directory: hello.html, hello.js and hello.wasm.

- hello.wasm is the file that contains the Webassembly code (the compiled code).
- hello.js is the "glue code" needed to allow JavaScript to call and "communicate" with WASM compiled code. Emscripten generates this automatically and it is absolutely needed in order to run WASM modules. If you compile without the -s WASM=1 flag this file will contain also the content of hello.wasm (but makes no difference in reality).
- hello.html is just a web page automatically generated that shows the result of your Webassembly code in a user friendly way. You don't actually need this file, but it is a cool way to quickly visualize what are you doing. You can tell Emscripten not to generate it by just using -o hello.js instead of -o hello.html (everything else remains as before).

If you haven't tried to open the file hello.html file yet, do it with the browser of your choice. You should see something like this:

![i](https://marcoselvatici.github.io/WASM_tutorial/ref/helloworld.png)

If you open it with certain browsers (like Chrome) you may get an error message instead of the words "Hello World!".
That is because the operation of loading of the WASM module is asynchronous, and some browsers (for security reasons) do not allow you to do this if the URL is of the kind file://path/to/file/file.html.
In order to solve that issue you can both change the browser you use for testing (Firefox will work) or run a local server this way:

1. open a terminal in the directory containing the file .html you want to run, and control your python version by typing:
    `python -V`

2. and then run:

    ```bash
    # if your version is 2.x

    python -m SimpleHTTPServer 8080

    # if your version is 3.x

    python -m http.server 8080
    ```

3. At this point go in the browser and open (type in the URL) localhost:8080. Note that the number 8080 is the same as the one you typed in the terminal previously (you can change it if you want, but be careful since not all the ports are for http).

Let's return talking about WASM.
The first thing that WASM does is execute the main of your code (if there is one). That is why you immediately see "Hello world!" printed in that pseudo-console.
Note that you don't actually need that pretty interface: try to open the console (press F12 or Ctrl+Shift+C). You should be able to see the words "Hello World!" printed there as well. Indeed, all your prints are printed in that console, and you can use them to debug your C/C++ code.

copy contents of first to second.

You can now try to create your own web page and run your short WASM-compiled code on that. Create a file .html and copy this simple code:

```html
<script src="hello.js"></script>
<p>Open the console to see the result!</p>
```

and open it in the browser.
You may see these warnings:

![i](https://marcoselvatici.github.io/WASM_tutorial/ref/warning.png)

Just don't worry about them, we are not using that method to create our WASM instance.

Important:
everything we did in this section is perfectly transferable on a C++ code. Try changing hello.c to hello.cpp:

copy contents of second to thirds

and compile it with:

```bash
# note that also emcc will work as well

em++ hello.cpp -o hello.html
```

Important:
You can also compile your code using optimizations using -Ox, try them out:

copy contents of second to fourth

```bash
# -O2 is already a pretty high level of optimization

emcc hello.c -o hello.js -O2 -s WASM=1
```

## Functions

So far we learnt how to build a simple WASM project. Let's make things more interesting by introducing functions.
Edit the hello.c code by adding a function to calculate the ith number in the Fibonacci sequence:

Copy fourth directory to the fifth directory.

```c
#include <stdio.h>

int fib(int n){
    if(n == 0 || n == 1)
        return 1;
    else
        return fib(n - 1) + fib(n - 2);
}

int main(){
    printf("Hello world!\n");
    int res = fib(5);
    printf("fib(5) = %d\n", res);
    return 0;
}
```

Try to compile and run it on the broswer. You should see the result in the console.

```bash
cd fifth
emcc hello.c -o hello.html -s WASM=1
```

Nothing special so far. But what if we want to call this function not just at the beginning (when main is executed) but when, for example, you press a button on the webpage?
This question basically translates to: how do I call C/C++ functions from the JavaScript of my web page?

The easiest ways to do this are to use two functions provided by the Emscripten "glue code":

- **ccall:** calls a compiled C function with the specified variables and return the result.
- **cwrap:** "wraps" a compiled C function and returns a JavaScript function you can call normally. That is, by far, more useful and we will focus on this method.

You can call it as follows:

```bash
var js_wrapped_fib = Module.cwrap("fib", "number", ["number"]);
```

and then you will be able to call the the C compiled fib function just with:

`var result = js_wrapped_fib(parameter);`

Let's focus a bit on the parameters we need to pass to cwrap:

- **name of the function:** name of the function in the C source code.
- **return type:** the return type of the function. This can be "number", "string" or "array", which correspond to the appropriate JavaScript types (use number for any C pointer), or for a void function it can be null (note: the JavaScript null value, not a string containing the word "null").
- **list of parameter's types (optional):** within square brackets. An array of the types of arguments for the function (if there are no arguments, this can be omitted). Types are as in return type, except that array is not supported as there is no way for us to know the length of the array.

Another important thing to notice is that Emscripten, during compilation, ignore all the functions that seem unused in order to get a smaller .wasm file. Thus, we need to let it know that we want to keep that functions "alive".
Again, there are two ways to do this:

copy fifth to sixth directory.

```c
#include <stdio.h>

int fib(int n){
    if(n == 0 || n == 1)
        return 1;
    else
        return fib(n - 1) + fib(n - 2);
}

int main(){
    printf("Hello world!\n");
    int res = fib(5);
    printf("fib(5) = %d\n", res);
    return 0;
}
```

In order to test it, compile the C code again, but this time tell the compiler to add cwrap as an extra exported runtime method by using this command:

<https://emscripten.org/docs/getting_started/FAQ.html#why-do-i-get-typeerror-module-something-is-not-a-function>

```bash
cd sixth
emcc hello.c -o hello.js -s WASM=1 -s EXPORTED_RUNTIME_METHODS=cwrap -s EXPORTED_FUNCTIONS=_fib
emcc: warning: `main` is defined in the input files, but `_main` is not in `EXPORTED_FUNCTIONS`. Add it to this list if you want `main` to run. [-Wunused-main]
```

Note that underscore before the function name, you will always have to add it.

In this example main is not executed automatically, indeed, it is not even exported.

Then edit and run your custom .html file as below:

```html
<script src="hello.js"></script>
<script>
var js_wrapped_fib = Module.cwrap("fib", "number", ["number"]);

function pressBtn(){
    console.log("The result of fib(5) is:", js_wrapped_fib(5));
}
</script>

<button onclick="pressBtn()">Click me!</button>
<p>Open the console to see the result!</p>
```

Each time you press the "Click me!" button you should see "The result of fib(5) is: 8" appearing on your console.

copy sixth to seventh directory

```bash
cd seventh
emcc hello.c -o hello.js -s WASM=1 -s EXPORTED_RUNTIME_METHODS=cwrap -s EXPORTED_FUNCTIONS=_main,_fib
```

Main is now automatically executed at the beginning. You can also call it from JS whenever you want if you wrap it by adding (note that there are no input parameters):

```python
var js_wrapped_main = Module.cwrap("main", "number");
```

## next pass array

At this point you may are wondering, how do I pass an array to a WASM function from JavaScript?
This will be covered in the section regarding the memory.

Important:
Exported functions need to be C functions (to avoid C++ name mangling). In order to solve that issue you can write in your C++ code:

```c++
extern "C"{

int my_func(/* ... */){
    // do stuffs
}

}
```

copy seventh to eighth directory

## Call JavaScript from C/C++

You can even call JavaScript functions from C/C++ code!
The easiest way to do this is to use the emscripten_run_script function. Edit your hello.c to:

```c
#include <stdio.h>
#include <emscripten.h>

int main(){
    printf("WASM is running!");
    emscripten_run_script("alert('I have been called from C!')");
    return 0;
}
```

Compile and run it and you should see an alert on the browser as soon as the WASM instance is ready.

```bash
# this works and main is exported
emcc hello.c -o hello.js -s WASM=1 -s EXPORTED_RUNTIME_METHODS=cwrap -s EXPORTED_FUNCTIONS=_main
```

You can also call your custom functions and even pass parameters! Edit your call in hello.c to:
`emscripten_run_script("set_background_color(1)");`

and your custom.html to:

```html
<script src="hello.js"></script>
<script>
function set_background_color(color_idx){
    var color = "red";
    if(color_idx == 1)   color = "blue";
    else if(color_idx == 2) color = "green";

    document.body.style.backgroundColor = color; // set the new background color
}
</script>
```

```bash
emcc hello.c -o hello.js -s WASM=1 -s EXPORTED_RUNTIME_METHODS=cwrap -s EXPORTED_FUNCTIONS=_main,_fib,_set_background_color_from_c

# Live reload enabled.
# hello.js:916 stdio streams had content in them that was not flushed. you should set EXIT_RUNTIME to 1 (see the Emscripten FAQ), or make sure to emit a newline when you printf etc.
# warnOnce @ hello.js:916Understand this error
# hello.js:916 (this may also be due to not including full filesystem support - try building with -sFORCE_FILESYSTEM)
# warnOnce @ hello.js:916Understand this error

emcc hello.c -o hello.js -s WASM=1 -s FORCE_FILESYSTEM -s EXPORTED_RUNTIME_METHODS=cwrap -s EXPORTED_FUNCTIONS=_main,_fib,_set_background_color_from_c

-s FORCE_FILESYSTEM
```

copy eighth to nineth

You may noticed that to pass parameters this way is not very easy.
Luckily, the function EM_ASM (and its variants) allows you to write JS code, call JS functions, pass parameters and even get return values, in a much more flexible way. Have a look at the following example (you don't need to change anything in the your .html code):

```python
#include <time.h>   // for time
#include <stdlib.h> // for rand
#include <stdio.h>
#include <emscripten.h>

int main(){
    printf("WASM is running!\n");
    
    srand(time(NULL));       // initialize random seed
    int color_idx = rand() % 3; // could be 0, 1 or 2
    
    EM_ASM(
        // here you can write inline javascript code!
        console.log("(1) I have been printed from inline JavaScript!");
        console.log("I have no parameters and I do not return anything :(");
        // end of javascript code
    );
        
    // note the underscore and the curly brackets (to pass one or more parameters)
    EM_ASM_({
        console.log("(2) I have received a parameter! It is:", $0);
        console.log("Setting the background to that color index!");
        set_background_color($0);
    }, color_idx);
        
    // note that you have to specify the return type after EM_ASM_
    int result = EM_ASM_INT({
        console.log("(3) I received two parameters! They are:", $0, $1);
        console.log("Let's return their sum!");
        return sum($0, $1);
    
        function sum(a, b){
            return a + b;
        }
    }, 13, 10);
    
    printf("(4) The C code received %d as result!\n", result);
    
    return 0;
}
```

```bash
emcc hello.c -o hello.js -s WASM=1 -s EXPORTED_RUNTIME_METHODS=cwrap -s EXPORTED_FUNCTIONS=_main,_fib,_set_background_color_from_c

emcc hello.c -o hello.js -s WASM=1 -s FORCE_FILESYSTEM -s EXPORTED_RUNTIME_METHODS=cwrap -s EXPORTED_FUNCTIONS=_main,_fib,_set_background_color_from_c

-s FORCE_FILESYSTEM
```

As you can see, there are many things you can do with these inline calls. Pretty cool, isn't it?

There is also a way to create a C API in JavaScript, but that requires a bit more work. If you are interested, you can find a good explanation of how to do it **[here](https://kripken.github.io/emscripten-site/docs/porting/connecting_cpp_and_javascript/Interacting-with-code.html#implement-a-c-api-in-javascript)**.

copy eighth to nineth

## Libraries

You may have noticed that we already compiled some libraries with Emscripten. However, these were all "standard" libraries. Indeed, Emscripten already provides these libraries ready to be compiled.
But what if you wanted to compile a non-standard library with Emscripten?

The process is very similar to the one we have already seen to compile the C files.
In case your library is small and has just some source files (.c or .cpp) and some headers file (.h) you just have to compile your "main" source file and your C code binding them together.
If you want, you can download the source and the header of this very simple **[expression parsing library](https://github.com/codeplea/tinyexpr)** (found on github):

- header **[tinyexpr.h](https://marcoselvatici.github.io/WASM_tutorial/ref/tinyexpr.h)** (2 KB),
- source **[tinyexpr.c](https://marcoselvatici.github.io/WASM_tutorial/ref/tinyexpr.c)** (20 KB).

Put them in the same folder and create another C file here containing:

```c
# include <stdio.h>
# include "tinyexpr.h"

int main(){
    // te_interp just evaluates the expression in the string and returns a float
    printf("The result of (2+23)/5-1 is: %f\n", te_interp("(2+23)/5-1", 0));
    return 0;
}
```

And then compile binding yours and the library code together like this:

`emcc hello.c tinyexpr.c -o hello.html -s WASM=1`
