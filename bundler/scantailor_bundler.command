#!/usr/bin/env fish

# to install fish :>brew install fish

cd (dirname (status --current-filename))

pwd 

set NAME "ScanTailor (Advanced)"
set VERSION "1.0.16"
set BUNDLE_VERSION "bundle "(date +%Y%m%d)" (v. $VERSION)"

set TARGET "./ScanTailor (Advanced).app"
set TEMPLATE "./scantailor_bundle_template.app"


cp -R "$TEMPLATE" "$TARGET"

#update the plist and compile it
echo "INFO - updating the bundle PLIST…"
set plist "$TARGET/Contents/Info.plist"
sed -i '' -e "s/\${Name}/$NAME/g" -e "s/\${Version}/$Version/g" -e "s/\${BundleVersion}/$BUNDLE_VERSION/"  $plist
plutil -convert binary1 "$plist"

echo "INFO - copying and relinking the binary…"
cp (which scantailor) "$TARGET/Contents/MacOS/ScanTailor"
macdeployqt "$TARGET" -dmg

echo "INFO - DONE ! (the App bundle is in the *.DMG file)"
