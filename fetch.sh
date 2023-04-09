#!/bin/bash

# Navigates through each github repo in my directory and runs `git fetch && git pull --rebase`

repo_dir="/home/$USER/code"
dir_absolute_paths=()

# If on Mac, change repo_dir
if [ $(uname) == "Darwin" ]; then
  repo_dir="/Users/$USER/code"
fi 

# Git commands I'll run in each repo
function git_cmds {
  git fetch && git pull --rebase
}

# Clear screen first
clear -x

# Pretty ASCII art :) 
echo -e '\033[32m
================================================================
________                          __________    _____      ______  
___  __ \__________________       ___  ____/______  /_________  /_ 
__  /_/ /  _ \__  __ \  __ \________  /_   _  _ \  __/  ___/_  __ \
_  _, _//  __/_  /_/ / /_/ //_____/  __/   /  __/ /_ / /__ _  / / /
/_/ |_| \___/_  .___/\____/       /_/      \___/\__/ \___/ /_/ /_/ 
             /_/                                                                        
================================================================
\033[0m'

echo -e "> \033[95mMoving to repo directory:\033[93m $repo_dir\033[0m"
cd "$repo_dir"
sleep 0.5
echo
echo -e "> \033[95mGathering child directories...\033[0m"
echo
sleep 0.5

# Iterate through each directory except 'not-git-repo' and return an array of their absolute paths
# for dir in $(ls --ignore 'not-git-repos'); do
# Can't use the above command subsitution because the `--ignore` option for `ls` is not on Macs 
for dir in $(find . -maxdepth 1 -type d -not -name "not-git-repos" -not -name "." -not -name ".*"); do
  dir_absolute_paths+=("$(realpath $dir)")
done

# cd to each directory in array and run command
for path in ${dir_absolute_paths[@]}; do
  echo -e "> \033[95mMoving to: \033[93m$path\033[0m"
  cd $path
  git_cmds
  echo
done

exit 0