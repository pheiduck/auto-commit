#!/bin/sh

# Clone Repo first change it to your Repo
git clone https://github.com/username/reponame.git
cd reponame

for (( ; ; ))
do

        cd $(pwd)
git add --all
timestamp() {
  date +"at %H:%M:%S on %d/%m/%Y"
}

git commit -am "Regular auto-commit $(timestamp)"

ping -c5 www.github.com && git push origin --all || echo "not connected"
    sleep 1
    if (disaster-condition)
	then
	break
    fi
done
