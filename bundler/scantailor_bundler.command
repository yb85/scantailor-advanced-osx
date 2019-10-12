#!/usr/bin/env fish

# to install fish :
#    > brew install fish
#
# WARNING you need to properly link homebrew qt5 installation :
#    > brew install qt
#    > brew link --force qt5
#
# Then add it to the fish-shell path (follow the instructions on screen) : 
#    > echo 'set -g fish_user_paths "/usr/local/opt/qt/bin" $fish_user_paths' >> ~/.config/fish/config.fish

cd (dirname (status --current-filename))

pwd 

set NAME "ScanTailor (Advanced)"
set VERSION (strings (which scantailor) | grep -E "\(build [0-9]{8,8}\)")
set BUNDLE_VERSION "bundle "(date +%Y%m%d)" (scantailor $VERSION)"

set TARGET "./ScanTailor (Advanced).app"
set TEMPLATE "./scantailor_bundle_template.app"

set BINDIR "$TARGET/Contents/MacOS"
set RELTRDIR "../share/scantailor-advanced/translations"

cp -R "$TEMPLATE" "$TARGET"

#update the plist and compile it
echo "INFO - updating the bundle PLIST…"
set plist "$TARGET/Contents/Info.plist"
sed -i '' -e "s/\${Name}/$NAME/g" -e "s/\${Version}/$Version/g" -e "s/\${BundleVersion}/$BUNDLE_VERSION/"  $plist
plutil -convert binary1 "$plist"

echo "INFO - copying the binary…"
mkdir -p "$BINDIR"
cp (which scantailor) "$BINDIR/ScanTailor"

echo "INFO - copying translations…"
pushd "$BINDIR"
mkdir -p "$RELTRDIR"
cp (dirname (which scantailor))/$RELTRDIR/*.qm "$RELTRDIR"
popd

echo "INFO - relinking the binary and DMG packaging…"
chmod 755 "$TARGET/Contents/MacOS/ScanTailor"
macdeployqt "$TARGET" -dmg

echo "INFO - DONE ! (the App bundle is in the *.DMG file)"
