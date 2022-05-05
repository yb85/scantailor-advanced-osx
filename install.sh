#!/bin/bash

cyan=`tput setaf 6`
reset=`tput sgr0`
pref="${cyan}[SCANTAILOR INSTALLER] ${reset}"



if ! command -v brew &> /dev/null
then
while true; do
    read -p "$pref Could not find the HOMEBREW package manager. Do you want to install it ? [Y/N]" yn
    case $yn in
        [Yy]* ) /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)";
                if [[ $(uname -m) == 'arm64' ]]; then
                    echo "export PATH=/opt/homebrew/bin:$PATH" >>  "$USER/.bashrc" ;
                fi
                source "$USER/.bashrc" ;
                brew update; break;;
        [Nn]* ) echo "$pref Installation aborted."; exit;;
        * ) echo "$pref Please answer yes or no [Y/N]";;
    esac
done
fi

if ! command -v git &> /dev/null
then
while true; do
    read -p "$pref Could not find the GIT version control system. Do you want to install it ? [Y/N]" yn
    case $yn in
        [Yy]* ) brew install git && source "$USER/.bashrc"; break;;
        [Nn]* ) echo "$pref Installation aborted."; exit;;
        * ) echo "$pref Please answer yes or no [Y/N]";;
    esac
done
fi

temp_dir="$(mktemp -d)" && \
    git clone "https://github.com/yb85/scantailor-advanced-osx.git" "${temp_dir}" && \
    cd "${temp_dir}/" && \
    brew install --formula $1 ./scantailor.rb && \
    echo "$pref Succesfuly installed SCANTAILOR, done."


        



