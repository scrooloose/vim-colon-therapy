For a healthy trailing colon ...
```
 ____________________________________________________________________________
/::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::\
|:::::::::'######:::'#######::'##::::::::'#######::'##::: ##:::::::::::::::::|
|::::::::'##... ##:'##.... ##: ##:::::::'##.... ##: ###:: ##:::::::::::::::::|
|:::::::: ##:::..:: ##:::: ##: ##::::::: ##:::: ##: ####: ##:::::::::::::::::|
|:::::::: ##::::::: ##:::: ##: ##::::::: ##:::: ##: ## ## ##:::::::::::::::::|
|:::::::: ##::::::: ##:::: ##: ##::::::: ##:::: ##: ##. ####:::::::::::::::::|
|:::::::: ##::: ##: ##:::: ##: ##::::::: ##:::: ##: ##:. ###:::::::::::::::::|
|::::::::. ######::. #######:: ########:. #######:: ##::. ##:::::::::::::::::|
|:::::::::......::::.......:::........:::.......:::..::::..::::::::::::::::::|
|::'########:'##::::'##:'########:'########:::::'###::::'########::'##:::'##:|
|::... ##..:: ##:::: ##: ##.....:: ##.... ##:::'## ##::: ##.... ##:. ##:'##::|
|::::: ##:::: ##:::: ##: ##::::::: ##:::: ##::'##:. ##:: ##:::: ##::. ####:::|
|::::: ##:::: #########: ######::: ########::'##:::. ##: ########::::. ##::::|
|::::: ##:::: ##.... ##: ##...:::: ##.. ##::: #########: ##.....:::::: ##::::|
|::::: ##:::: ##:::: ##: ##::::::: ##::. ##:: ##.... ##: ##::::::::::: ##::::|
|::::: ##:::: ##:::: ##: ########: ##:::. ##: ##:::: ##: ##::::::::::: ##::::|
|:::::..:::::..:::::..::........::..:::::..::..:::::..::..::::::::::::..:::::|
\----------------------------------------------------------------------------/
     \
      \
  /\          /\
 ( \\        // )
  \ \\      // /
   \_\\||||//_/
     / _  _ \/
     |(o)(o)|\/
     |      | \/
     \      /  \/_____________________
      |____|     \\                  \\
     /      \     ||                  \\
     \ 0  0 /     |/                  |\\
      \____/ \    V           (       / \\
       / \    \     )          \     /   \\
      / | \    \_|  |___________\   /     ""
                  ||  |     \   /\  \
                  ||  /      \  \ \  \
                  || |        | |  | |
                  || |        | |  | |
                  ||_|        |_|  |_|
                 //_/        /_/  /_/

```

# Introduction

Often I will run unit tests, or linters etc and will see output like this:
```
spec/services/foo_spec.rb:39:7: C: Style/StringLiterals: Prefer single-quoted strings ...
```
If I want to investigate, I will double click the filename and copy / paste it
into an `:edit` command. For my setup, this would select the line number etc and
result in the following:
```
:e spec/services/foo_spec.rb:39:7:
```

I would then have to strip off the `:39:7:`.

Enter Colon Therapy! With this plugin, Vim will edit the file and jump to line
39. Everything after the first colon is treated as a line number. The rest is
ignored.

If there is only a colon, then this will simply be chopped off and ignored.

# Installation

Pick your favourite plugin manager and follow its instructions.

For example, for [vundle](https://github.com/VundleVim/Vundle.vim), just stick
this in your vimrc:

```
Plugin 'scrooloose/vim-colon-therapy'
```

# Usage

Edit a filename with a trailing colon and line number. One of these forms:

```
:e [file]:[line num]               => edits [file], jumps to [line num]
:e [file]:[line num]:[other junk]  => edits [file], jumps to [line num], ignores [other junk]
:e [file]:                         => edits [file], ignores colon
```

These are the forms I encounter regularly, but there may be more.
