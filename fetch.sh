#!/bin/bash

set -e

red="\033[31m"
reset="\033[0m"
green="\033[32m"
yellow="\033[93m"
magenta="\033[35m"

dir_absolute_paths=()
main_repo_dir="/home/${USER}/code"

if [ $(uname) == "Darwin" ]; then
	main_repo_dir="/Users/${USER}/code"
fi 

git_cmds() {
    branches=()
    branches+=$(git branch -l | awk '$1 == "*" {print $2} $1 != "*" {print $1}')

    for branch in ${branches}; do
		git switch ${branch}
		git pull --rebase 2>/dev/null

		exit_status=$?
		if [ ${exit_status} -eq 128 ]; then
        	echo -e "\n\t${red}Cannot pull with rebase: You have unstaged changes.${reset}\n"
		fi	
    done
}

echo -e "${green}
================================================================
________                          __________    _____      ______  
___  __ \__________________       ___  ____/______  /_________  /_ 
__  /_/ /  _ \__  __ \  __ \________  /_   _  _ \  __/  ___/_  __ \\
_  _, _//  __/_  /_/ / /_/ //_____/  __/   /  __/ /_ / /__ _  / / /
/_/ |_| \___/_  .___/\____/       /_/      \___/\__/ \___/ /_/ /_/ 
             /_/                                                                        
================================================================
${reset}"

echo -e "> ${magenta}Moving to repo directory:${yellow} ${main_repo_dir}${reset}"
cd "${main_repo_dir}"

echo -e "\n> ${magenta}Gathering child directories...${reset}\n"
for dir in $(ls); do
	cd ${main_repo_dir}/${dir}
	if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
		dir_absolute_paths+=("$(pwd)")
	fi
done

cd "${main_repo_dir}/projects"
for dir in $(ls); do
	cd ${main_repo_dir}/projects/${dir}
	if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
		dir_absolute_paths+=("$(pwd)")
	fi
done

for path in ${dir_absolute_paths[@]}; do
	echo -e "> ${magenta}Moving to: ${yellow}${path}${reset}"
	cd ${path}
	git_cmds
	echo
done
