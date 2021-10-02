# The Eirini team's [n]vim config

## Guide to key mappings and useful commands

The leader key is \<space\>.

### LSP

| Key combo          | Description                              |
| ------------------ | ---------------------------------------- |
| gd                 | Go to definition                         |
| gr                 | Find references in quicklist             |
| gy                 | Go to type definition                    |
| gi                 | Find implementations in quicklist        |
| K                  | Show documentation                       |
| gs                 | Signature help                           |
| gh                 | Show LSPSaga finder (q to exit)          |
| \<leader\>ca       | Code action (also works on visual range) |
| \<leader\>rn       | Rename                                   |
| \<leader\>en or ]g | Go to next error                         |
| \<leader\>ep or [g | Go to previous error                     |
| \<leader\>eb       | Show buffer errors in location list      |
| \<leader\>ea       | Show project errors in location list     |
| \<f8\>             | Toggle file outline                      |
| \<leader\>q        | Toggle quickfix window                   |
| \<leader\>l        | Toggle location window                   |

### Searching

| Key combo    | Description                                                                   |
| ------------ | ----------------------------------------------------------------------------- |
| \<leader\>ss | `rg` for term into quicklist (use empty term to search for term under cursor) |
| \<leader\>sr | `rg` with FzF                                                                 |
| \<leader\>st | `rg` term under cursor with FzF                                               |

### Directory Structure

| Key combo          | Description                             |
| ------------------ | --------------------------------------- |
| \                  | Toggle NERDTree                         |
| \|                 | Goto current file in NERDTree           |
| \<C-p\>            | Fuzzy find files                        |
| \<leader\>fo       | Fuzzy find open buffers                 |
| \<leader\>fm       | Fuzzy find file history                 |
| \<leader\>fd       | Delete current buffer                   |
| \<leader\>fn       | Next buffer                             |
| \<leader\>fp       | Previous buffer                         |
| \<leader\>fa or :A | Toggle between go code and test         |
| :AS                | Open test / prod code in split          |
| :AV                | Open test / prod code in vertical split |

### Comments

| Key combo       | Description                                |
| --------------- | ------------------------------------------ |
| gcc or \<C-\_\> | Toggle comment                             |
| gc              | Toggle comment on selection or text object |

### Snippets

| Key combo | Description                         |
| --------- | ----------------------------------- |
| \<C-j\>   | Expand snippet                      |
| \<C-f\>   | Jump to next placeholder in snippet |

### Testing

| Key combo    | Description                      |
| ------------ | -------------------------------- |
| \<leader\>tt | Run the test where the cursor is |
| \<leader\>t. | Re-run the last test             |
| \<leader\>tf | Run the tests in this file       |
| \<leader\>ts | Run the tests in this directory  |
| \<leader\>tg | Navigate to the last test        |

### Github

| Key combo    | Description                                                                   |
| ------------ | ----------------------------------------------------------------------------- |
| \<leader\>gh | Open github at file or file selection (or print URL if cannot open a browser) |

### tpope's vim-unimpaired

See https://github.com/tpope/vim-unimpaired/blob/master/doc/unimpaired.txt, or
`:h unimpaired` for a full list. Here are some notable mappings.

| Key combo  | Description                                                        |
| ---------- | ------------------------------------------------------------------ |
| ]q         | Navigate to next item in quickfix list                             |
| [q         | Navigate to previous item in quickfix list                         |
| ]\<C-q\>   | Navigate to next item in a different file in the quickfix list     |
| [\<C-q\>   | Navigate to previous item in a different file in the quickfix list |
| ]l         | Navigate to next item in location list                             |
| [l         | Navigate to previous item in location list                         |
| ]\<C-l\>   | Navigate to next item in a different file in the location list     |
| [\<C-l\>   | Navigate to previous item in a different file in the location list |
| ]c         | Jump to next change when diff'ing                                  |
| [c         | Jump to previous change when diff'ing                              |
| ]\<space\> | Insert a blank line below                                          |
| [\<space\> | Insert a blank line above                                          |
| ]e         | Move line down                                                     |
| [e         | Move line up                                                       |

### tpope's fugitive

Used to do git commands within vim. Best to look at the docs:
https://github.com/tpope/vim-fugitive, or `:h fugitive`.

### tpope's eunuch

Do unix file commands from within vim

| Command    | Description                                                           |
| ---------- | --------------------------------------------------------------------- |
| :Delete    | Remove the file from disk and delete the buffer                       |
| :Move      | Like :saveas but remove the old file after                            |
| :Rename    | Like :Move but relative to the file's directory                       |
| :Chmod     | chmod                                                                 |
| :Mkdir     | mkdir                                                                 |
| :SudoEdit  | Edit a file using sudo. Save it with :w!                              |
| :SudoWrite | Use sudo to write a file to disk, that you didn't open with :SudoEdit |
