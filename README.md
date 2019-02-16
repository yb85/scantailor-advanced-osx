# scantailor-advanced-osx
Homebrew formula and App bundler for Scantailor (Advanced)

See [4lex4/scantailor-advanced](https://github.com/4lex4/scantailor-advanced) for the original project.

**Look at the [Releases](https://github.com/yb85/scantailor-advanced-osx/releases) section for a bundled App (Mojave_x64).**

## Installing via homebrew

1. clone the repository
```
git clone "https://github.com/yb85/scantailor-advanced-osx.git"
cd ./scantailor-advanced-osx
```

2. with [homebrew](https://brew.sh) installed and updated, run :

```
brew install ./scantailor.rb
```
Compilation takes time, you can inspect the logs for more details at `~/Library/Logs/Homebrew/scantailor` with OS X Console.

You should now be able to run Scantailor from the command-line : `scantailor`

## Bundling your binary
To use the bundler, you need the fish shell (`brew install fish`) and the utility [macdeployqt](https://doc.qt.io/qt-5.9/osx-deployment.html) to do the linking. Simply run `bundler/scantailor_bundler.command`

The bundler script will use the scantailor binary which is in your shell path (the value printed out by `which scantailor`).
