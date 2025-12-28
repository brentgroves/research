# Pascal
It adds support for the Pascal language and its dialects like Delphi and FreePascal.

Here are some of the features that Pascal provides:

Syntax highlighting for files, forms and projects
A huge set of Snippets
Source code navigation
Features
Coding with style
Syntax Highlighting
Pascal supports full syntax highlighting for Delphi and FreePascal


https://marketplace.visualstudio.com/items?itemName=alefragnani.pascal

Update two tags:

FPC_BIN_PATH: The full compiler location. If its PATH is already in Environment Variables, simply use FPC_BIN filename
YOUR_FREEPASCAL_PROJECT_OR_FILE: The project/file being built.

{
   "version": "2.0.0",
   "tasks": [
      {
         "label": "Pascal",
         "type": "shell",
         "windows": {
            "command": "FPC_BIN_PATH"
         },
         "linux": {
            "command": "FPC_BIN_PATH"
         },
         "presentation": {
            "reveal": "always",
            "panel": "new"
         },
         "args": [
            {
               "value": "YOUR_FREEPASCAL_PROJECT_OR_FILE",
               "quoting": "escape"
            }
         ],
         "problemMatcher": {
            "owner": "external",
            "pattern": {
               "regexp": "^([\\w]+\\.(p|pp|pas))\\((\\d+)\\,(\\d+)\\)\\s(Fatal|Error|Warning|Note):(.*)",
               "file": 1,
               "line": 3,
               "column": 4,
               "message": 6
            }
         },
         "group": {
            "kind": "build",
            "isDefault": true
         }
      }
   ]
}

https://github.com/alefragnani/vscode-pascal-formatter#features
https://wiki.freepascal.org/PTop
Features
Standardise your Pascal code!

It uses external tools (engines) to format the code, so you must install them prior to use the Format Document and Format Selection commands.

FreePascal PToP: http://wiki.freepascal.org/PTop (Windows, Linux and Mac OS X)
Jedi Code Format: http://jedicodeformat.sourceforge.net/ (Windows only)
Jedi Code Format (Quadroid): https://github.com/quadroid/jcf-pascal-format (Windows, Linux and Mac OS X)
Embarcadero Formatter: http://docwiki.embarcadero.com/RADStudio/Sydney/en/Formatter.EXE,_the_Command_Line_Formatter (Windows only)
If you intend to format pieces of selected texts instead of the entire file, you should use FreePascal PToP, because the Jedi Code Format and Embarcadero Formatter only works for entire files.

