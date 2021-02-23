#!/bin/sh

# Create Symlink first

ln -s commit.sh /bin/auto-commit

# Clone Repo first change it to your Repo

echo "Your github username: "
read -r
username=$REPLY

echo "Your github reponame: "
read -r
reponame=$REPLY


git clone https://github.com/$username/$reponame.git
cd $reponame

for (( ; ; ))
do

        cd $(pwd)
git add --all
timestamp() {
  date +"at %H:%M:%S on %d/%m/%Y"
}

git commit -sam "Regular auto-commit $(timestamp)"

ping -c5 www.github.com && git push origin --all || echo "not connected"
    sleep 1
    if (disaster-condition)
	then
	break
    fi
done
