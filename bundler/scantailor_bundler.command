#!/usr/bin/env fish

# to install fish :
#    > brew install fish
#
# WARNING you need to have Qt6 installed and properly linked, as of feb 2022 :
#    > brew install qt
# or 
#    > brew install qt@6

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

# update the plist and compile it
echo "INFO - updating the bundle PLIST…"
set plist "$TARGET/Contents/Info.plist"
set LC_CTYPE C && set LANG C && sed -i '' -e "s/\${Name}/$NAME/g" -e "s/\${Version}/$Version/g" -e "s/\${BundleVersion}/$BUNDLE_VERSION/" $plist
plutil -convert binary1 "$plist"

echo "INFO - copying the binary…"
mkdir -p "$BINDIR"
cp (which scantailor) "$BINDIR/ScanTailor"

echo "INFO - copying translations…"
pushd "$BINDIR"
mkdir -p "$RELTRDIR"
cp (dirname (which scantailor))/$RELTRDIR/*.qm "$RELTRDIR"
popd

echo "INFO - relinking the binary …"
chmod 755 "$TARGET/Contents/MacOS/ScanTailor"
set qtprefix (brew --prefix qt)

set devcert (security find-identity -v -p codesigning | grep -Eo '[0-9A-F]{40}' | head -n1)

$qtprefix/bin/macdeployqt "$TARGET" -libpath="$qtprefix/lib" -codesign="$devcert"

# DIRTY FIX FOR @rpath LINKING ISSUE
cp -R $qtprefix/lib/QtDBus.framework "$TARGET/Contents/Frameworks"
set dbuslib (otool -L "$TARGET/Contents/Frameworks/QtDBus.framework/Versions/A/QtDBus" | grep -Eo "^.*/libdbus-[0-9.]+.dylib" | xargs)
cp "$dbuslib" "$TARGET/Contents/Frameworks/"(basename $dbuslib)
install_name_tool -change "$dbuslib" "@executable_path/../Frameworks/"(basename $dbuslib) "$TARGET/Contents/Frameworks/QtDBus.framework/Versions/A/QtDBus"

# Add the correct rpath to the executable so that @rpath resolves to the Frameworks folder.
install_name_tool -add_rpath "@executable_path/../Frameworks" "$TARGET/Contents/MacOS/ScanTailor"

# Re-sign the entire app bundle using the certificate hash.
codesign --force --deep --verbose=2 --sign "$devcert" "$TARGET"

# Verify the signature.
codesign --verify --verbose=4 "$TARGET"

echo "INFO - DONE !"
