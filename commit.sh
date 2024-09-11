# Copyright (c) Philip H.
#!/bin/sh

# Ensure the script is run as root
if [ "$(whoami)" != 'root' ]; then
  echo "Please run the script with sudo privileges."
  exit 1
else
  echo "[OK] Running with sudo privileges."
fi

# Get the Git URL, username, and repository name
read -r -p "URL (github or gitlab): " url
read -r -p "Your username / projectname: " username
read -r -p "Your repository name: " reponame

# Validate inputs
if [ -z "$url" ] || [ -z "$username" ] || [ -z "$reponame" ]; then
  echo "Error: URL, username, and repository name cannot be empty."
  exit 1
fi

# Clone the repository
git clone "https://$url/$username/$reponame.git"
if [ $? -ne 0 ]; then
  echo "Error: Failed to clone the repository. Check your URL and credentials."
  exit 1
fi

cd "$reponame" || { echo "Error: Directory $reponame not found."; exit 1; }

# Function to get a timestamp
timestamp() {
  date +"%Y-%m-%d %H:%M:%S"
}

# Variables for disaster conditions
max_failures=3          # Max allowed failed pings
fail_count=0            # Counter for failed ping attempts
max_repo_size=100000    # Max repo size in kilobytes (100MB)

# Auto-commit and push in an infinite loop
while true; do
  # Stage all changes
  git add --all
  
  # Check if there are changes to commit
  if git diff --cached --exit-code > /dev/null; then
    echo "No changes to commit at $(timestamp)."
  else
    # Commit with timestamp
    git commit -m "Auto-commit on $(timestamp)"
  fi

  # Disaster Condition 1: Ping fails multiple times
  if ! ping -c5 "www.$url" > /dev/null; then
    fail_count=$((fail_count + 1))
    echo "Ping failed ($fail_count/$max_failures)."
    if [ $fail_count -ge $max_failures ]; then
      echo "Error: Unable to reach $url after $fail_count attempts. Exiting..."
      exit 1
    fi
  else
    fail_count=0  # Reset fail count on success
  fi

  # Push the changes if ping was successful
  git push || { echo "Error: Push failed. Exiting..."; exit 1; }

  # Disaster Condition 2: Check repository size
  repo_size=$(du -sk . | awk '{print $1}')
  if [ "$repo_size" -ge "$max_repo_size" ]; then
    echo "Error: Repository size exceeds $max_repo_size KB. Exiting..."
    exit 1
  fi

  # Sleep before the next commit cycle
  sleep 60  # Adjust the sleep time to suit your needs

  # Disaster Condition 3: Implement your custom logic here, if needed
  # Example: if certain files are missing or there are other issues.
done
