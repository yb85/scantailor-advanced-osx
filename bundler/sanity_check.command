#!/usr/bin/env fish

set APP "./ScanTailor (Advanced).app"

alias cred "tput setaf 1"
alias cgreen "tput setaf 2"
alias cyellow "tput setaf 3"
alias cblue "tput setaf 4"
alias ccyan "tput setaf 6"

alias creset "tput sgr0"

cd (dirname (status --current-filename))

for exe in (find "$APP" -type f)
# consider only files which lipo recognizes as binary executable
	if lipo -info "$exe" 1> /dev/null 2> /dev/null
		cblue;echo "INFO — Checking \"$exe\" …";cred
		#use tail to remove the first two lines which show the file itself and its loaded path
		otool -L "$exe" | tail -n +3 | grep --color=never -P "^\s*/usr/local";cyellow
		otool -L "$exe" | tail -n +3 | grep --color=never -P "^\s*(/usr/lib|/usr/bin|/[^u])";cgreen
		otool -L "$exe" | tail -n +3 | grep  --color=never -P "^\s*@executable_path";creset
	else 
		ccyan;echo "INFO — Skipping \"$exe\" …";creset
	end
end
echo ""
echo "INFO — Color code for inspection :"(cgreen)
echo "        * relative linking (OK) "(cyellow)
echo "        * absolute linking to system dir (PROBABLY OK) "(cred)
echo "        * absolute linking to local dir (NOT OK)";creset
