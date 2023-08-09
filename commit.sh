#Copyright (c) Philip H.
#!/bin/sh

# Create Symlink first needs sudo btw :P

if [ $(whoami) != 'root' ]; then
  echo "Please run with sudo privileges"
  exit 0
else

sudo ln -s commit.sh /bin/auto-commit
fi

# Clone Repo first the script asks for giturl, username and reponame

echo "URL Type github or gitlab: "
read -r
url=$REPLY

echo "Your username / projectname: "
read -r
username=$REPLY

echo "Your reponame: "
read -r
reponame=$REPLY


git clone https://$url/$username/$reponame.git
cd $reponame

# Now auto-commit is running...

for (( ; ; ))
do

        cd $(pwd)
git add --all
timestamp() {
  date +"at %H:%M:%S on %d/%m/%Y"
}

git commit -sam "Regular auto-commit $(timestamp)"

ping -c5 www.$url && git push origin --all || echo "not connected"
    sleep 1
    if (disaster-condition)
	then
	break
    fi
done
