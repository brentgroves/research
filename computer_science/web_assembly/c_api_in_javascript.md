# **[Implement a C API in JavaScript](https://emscripten.org/docs/porting/connecting_cpp_and_javascript/Interacting-with-code.html#implement-a-c-api-in-javascript)**

It is possible to implement a C API in JavaScript! This is the approach used in many of Emscripten’s libraries, like SDL1 and OpenGL.

You can use it to write your own APIs to call from C/C++. To do this you define the interface, decorating with extern to mark the methods in the API as external symbols. You can then implement the symbols in JavaScript by simply adding their definition to one of the core JS library files. Undefined native symbols will be resolved by looking for them in JavaScript library files.

The **[core JS library](https://github.com/emscripten-core/emscripten/blob/main/src/lib/)** files are where you will find Emscripten internals. For example, parts of Emscripten’s libc are implemented there. You can also put the JavaScript implementation in your own library file and add it using the **[emcc option](https://emscripten.org/docs/tools_reference/emcc.html#emcc-js-library)** --js-library. See **[test_jslib](https://github.com/emscripten-core/emscripten/blob/4.0.9/test/test_core.py#L6261)** in test/test_other.py for a complete working example, including the syntax you should use inside the JavaScript library file.

As a simple example, consider the case where you have some C code like this:

```c
extern void my_js(void);

int main() {
  my_js();
  return 1;
}
```

When using C++ you should encapsulate extern void my_js(); in an extern "C" {} block to prevent C++ name mangling:

```c
extern "C" {
  extern void my_js();
}
```

Then you can implement my_js in JavaScript by simply adding the implementation to library.js (or your own file). Like our other examples of calling JavaScript from C, the example below just creates a dialog box using a simple alert() function.

```javascript
my_js: function() {
  alert('hi');
},
```

If you add it to your own file, you should write something like

```javascript
addToLibrary({
  my_js: function() {
    alert('hi');
  },
});
```

addToLibrary copies the properties of the input object into LibraryManager.library (the global object where all JavaScript library code lives). In this case its adds a function called my_js onto this object.

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
