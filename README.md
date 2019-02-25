# Data Physics User Manual Document and Website Generator

## Requirements
- _for Windows 7_: Powershell v3+ - Windows6.1-KB2506143-x64 - https://www.microsoft.com/en-us/download/details.aspx?id=34595

### WEB
- Hugo - https://gohugo.io/getting-started/installing/#less-technical-users - https://github.com/gohugoio/hugo/releases/latest
- MathJax - https://github.com/mathjax/MathJax/releases/latest

### PDF
- MikTex - https://miktex.org/download - https://github.com/MiKTeX/miktex/releases
- Pandoc - https://pandoc.org/installing.html - https://github.com/jgm/pandoc/releases/latest

---

## Instructions
- Click Start and run `PowerShell.exe` as administrator.
- Type `Set-ExecutionPolicy Unrestricted`.

  **Run these scripts in order from the `Installation` folder**
  - `0-install_chocolatey.ps1`
  - `1-install_dependencies.ps1`
  - `2-download-repository.ps1`

- Default installation folder is `C:\Data-Physics-User-Manual-Generator`.
- Extract user manual package under `Contents` directory.
- Run `Compile.ps1` to generate the website and/or the PDF.
