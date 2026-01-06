# How to Remove a Sub-Module

<https://www.atlassian.com/git/articles/core-concept-workflows-and-tips>

How do I remove a submodule?
It is a fairly common need but has a slightly convoluted procedure. To remove a submodule you need to:

1. Delete the relevant line from the .gitmodules file.
2. Delete the relevant section from .git/config.
3. Run git rm --cached path_to_submodule (no trailing slash).
4. delete submodule
5. Commit and delete the now untracked submodule files.
6. Update shell scripts.
