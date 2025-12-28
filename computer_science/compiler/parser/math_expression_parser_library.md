# **[expression parsing library](https://github.com/codeplea/tinyexpr)**

If you want, you can download the source and the header of this very simple **[expression parsing library](https://github.com/codeplea/tinyexpr)** (found on github)

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
