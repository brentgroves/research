# **[]()**

Pyodide is a Python distribution that runs the CPython interpreter inside a web browser or Node.js environment using WebAssembly (Wasm). It makes it possible to run Python code and install Python packages directly in the client-side environment, without needing a back-end Python server or cloud infrastructure.

## Key Features

- **WebAssembly (Wasm) Based:** Pyodide ports the CPython interpreter to Wasm, allowing it to execute Python code performantly within the browser's security sandbox.
- **Package Management:** It includes micropip, a package manager that allows users to install pure Python packages from PyPI in the browser.
- **Scientific Python Stack Support:** Many packages with C, C++, and Rust extensions, including core scientific libraries like NumPy, pandas, SciPy, and Matplotlib, have been ported for use with Pyodide.
- **JavaScript ⟺ Python Interoperability:** Pyodide offers a robust foreign function interface (FFI) that enables seamless mixing of Python and JavaScript code, including full support for error handling and async/await functionality.
- **Web API Access:** When running in a browser, Python code has full access to Web APIs and the Document Object Model (DOM).

## Use Cases

- **Interactive Web Applications:** Developers can create highly interactive web applications using Python, such as data science notebooks (like JupyterLite) or data visualization tools, that perform computations locally in the user's browser.
- **Educational Tools:** It removes the barrier of needing to install and configure Python locally, making it an excellent tool for beginner programmers and students.
- **Client-Side Tooling:** Pyodide is used in projects like the Python extension for VS Code to run Python tooling (e.g., for linting or intellisense) in the browser environment.
- **Serverless Functions:** It can run in serverless environments like **[Cloudflare Workers](https://workers.cloudflare.com/)**, allowing Python logic to be executed at the edge.
Pyodide was originally created in 2018 by Michael Droettboom at Mozilla as part of the Iodide project and is now an independent, community-driven open-source project.
