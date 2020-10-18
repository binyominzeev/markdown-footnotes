# markdown-footnotes

A script that generates PDF from Markdown with footnotes (using LibreOffice)

## Usage

Run `md2odt.pl`. It needs one parameter, the MD file you want to generate. Output will be generated in current directory, ``output.odt`` and ``output.pdf``.

First configure its parameters: set `$wd` to point to the working directory in which you have extracted it.

Also, adjust, if necessary the LibreOffice version to the one installed on your computer (at the bottom of the code).

Also, use something else instead of `cat` if you want to run on non-Linux OS.

## Example

In `test/input.md` there is an example file with Markdown & footnotes. Try it with:

```
./md2odt.pl test/input.md 
```


