<p align="left">
<h1> auto-commit </h1>
</p>

<p align="right">
  <img src="./Animated_internal_gear.gif" width="80" height="80">
</p>

Dev Space | Simple Script for automate Commits to your own Git Repo | Supports Linux / Unix

# Update:

- Script run infinity loop


# Known Issues:

- Not a real auto-commit
- script cd goes in current Working Directory
- Symlink will be not set at the first time

# Workarounds:

- Execute the script once
- Make sure you are in the git repo, where you want to use the script
- ln -s commit.sh /bin/auto-commit
