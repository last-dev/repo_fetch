# Automate Repo Updates

## **Goal**

The goal of this script is to automate having to fetch any of the latest updates from my remote repositories and pull them down to their respective local repository. This can be time consuming based on my workflow.

This will force me to stay ontop deleting unused branches. Lol.

## **Setup**

I can keep my script up-to-date by creating a symbolic link to my `/usr/local/bin` directory:

```bash
sudo ln -s $HOME/code/projects/repo_fetch/fetch.sh /usr/local/bin/fetch.sh
```
