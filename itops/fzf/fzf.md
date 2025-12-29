# fzf

## fzf text in files

To search for text within files using fzf interactively, you need to combine it with a tool that searches file contents like grep or, more efficiently, ripgrep (rg). fzf itself is a general-purpose filter that operates on lists provided to its standard input.
Here are the recommended methods:
Recommended: Use ripgrep (rg) with fzf
Ripgrep is highly recommended for this task as it is very fast and respects .gitignore files by default. This provides a clean, interactive way to search for text within your project files and jump to the match in your editor.
Install prerequisites: Make sure you have fzf and ripgrep (rg) installed. Optionally, install bat for rich file content previews.
Run the command: Use this command in your terminal:
bash
rg --color=always --line-number --no-heading "$1" | fzf --ansi --delimiter : --nth 1.. | cut -d: -f1,2 | xargs -r ${EDITOR:-vim} +
rg ... "$1": Executes ripgrep for an initial search term (if provided as a script argument) and pipes the results to fzf. The options add color and line numbers.
fzf --ansi --delimiter : --nth 1..: Starts the interactive fuzzy finder. It understands the ANSI colors from rg, uses : as a delimiter, and makes the file path/line number the primary search field.
cut -d: -f1,2: Extracts the filename and line number from the selected line.
xargs -r ${EDITOR:-vim} +: Opens the selected file in your default editor ($EDITOR) or vim at the specified line number.
Define an alias/function (optional): To make this command easier to use, add a shell function to your .~/bashrc or .~/zshrc file:
bash
fif() {
  rg --color=always --line-number --no-heading "$*" | \
  fzf --ansi --delimiter : --nth 1.. | \
  cut -d: -f1,2 | xargs -r ${EDITOR:-vim} +
}
After reloading your shell configuration (source ~/.bashrc), you can simply run fif "your search term".
Alternative: A simple interactive grep
If you just want an interactive fuzzy filter over all lines containing your search term (without jumping to an editor), you can pipe the output of a recursive grep into fzf.
bash
grep -r "your text" . | fzf
This will display all matching lines interactively. When you select a line and press Enter, it will be printed to standard output.
For more sophisticated configurations, including live preview windows using tools like bat, you can refer to the fzf GitHub repository documentation.
