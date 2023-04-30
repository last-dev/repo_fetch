#!/bin/bash
# Navigates through each github repo in my directory and runs `git pull --rebase`

main_repo_dir="/home/$USER/code"
dir_absolute_paths=()

# If on Mac, change `main_repo_dir` to `/Users/$USER/code`
if [ $(uname) == "Darwin" ]; then
  main_repo_dir="/Users/$USER/code"
fi 

# Runs git commands on each branch of the repo
function git_cmds {
    # Add all branches in the repo to an array
    branches=()
    branches+=$(git branch -l | awk '$1 == "*" {print $2} $1 != "*" {print $1}')

    # For each branch, switch to it first and then run command
    for branch in $branches; do
      git switch $branch
      git pull --rebase 2>/dev/null

      # Cleaning up stderr that is displayed. Less clutter, directly to the point.
      exit_status=$?
      if [ $exit_status -eq 128 ]; then
        echo -e "\n\t\033[31mCannot pull with rebase: You have unstaged changes.\033[0m\n"
      fi
    done
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

echo -e "> \033[95mMoving to repo directory:\033[93m $main_repo_dir\033[0m"
cd "$main_repo_dir"
sleep 0.5
echo
echo -e "> \033[95mGathering child directories...\033[0m"
echo
sleep 0.5

# Iterate through each directory except 'not-git-repo' and return an array of their absolute paths
# for dir in $(ls --ignore 'not-git-repos'); do
# Can't use the above command subsitution because the `--ignore` option for `ls` is not on Macs by default
for dir in $(find . -maxdepth 1 -type d -not -name "not-git-repos" -not -name "projects" -not -name "." -not -name ".*"); do
  dir_absolute_paths+=("$(realpath $dir)")
done

# Move into dedicated project directory and add them to the array
cd "$main_repo_dir/projects"
for dir in $(find . -maxdepth 1 -type d -not -name "." -not -name ".*"); do
  dir_absolute_paths+=("$(realpath $dir)")
done

# Navigate to each path in the array and run commands
for path in ${dir_absolute_paths[@]}; do
  echo -e "> \033[95mMoving to: \033[93m$path\033[0m"
  cd $path
  git_cmds
  echo
done

exit 0