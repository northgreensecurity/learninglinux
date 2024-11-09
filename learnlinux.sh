#!/bin/bash

# Get the original user's home directory, even when using sudo
if [ -n "$SUDO_USER" ]; then
  USER_HOME=$(eval echo "~$SUDO_USER")
else
  USER_HOME="$HOME"
fi

LEARNING_DIR="$USER_HOME/learninglinux"

# Get the username of the user who invoked the script
user=$(whoami)
if [ -n "$SUDO_USER" ]; then
  user="$SUDO_USER"
fi


# Display a banner at the top of the script
echo -e "\033[1;34m##############################################"
echo -e "\033[1;32m    Learning Linux by North Green Security       \033[1;34m"
echo -e "\033[1;34m##############################################\033[0m"

# Ensure the learninglinux directory exists in the user's home directory
mkdir -p "$LEARNING_DIR"

# Menu for the rest of the options
echo -e "\033[1;35m--------------------------------\033[0m"
echo -e "\033[1;36mPlease select an option:\033[0m"
echo -e "\033[1;33m1)\033[0m \033[1;37mCreate data for exercises\033[0m"
echo -e "\033[1;33m2)\033[0m \033[1;37mCreate users for privilege exercises\033[0m"
echo -e "\033[1;33m3)\033[0m \033[1;37mDelete users for privilege exercises\033[0m"
echo -e "\033[1;33m4)\033[0m \033[1;37mCreate files for permissions exercises\033[0m"
echo -e "\033[1;33m5)\033[0m \033[1;37mCreate files for compression exercises\033[0m"
echo -e "\033[1;33m6)\033[0m \033[1;37mCreate files for finding exercises\033[0m"
echo -e "\033[1;33m7)\033[0m \033[1;37mSetup Docker container for SCP exercise\033[0m"
echo -e "\033[1;33m0)\033[0m \033[1;31mExit\033[0m"
echo -e "\033[1;35m--------------------------------\033[0m"

while true; do  
  read -p "Enter your choice: " choice

  case $choice in
    1)
      # Create a larger, randomized fruit list
      fruits=("apple" "banana" "orange" "grape" "pear" "watermelon" "kiwi" "mango" "cherry" "peach" "plum" "pineapple" "strawberry")
      exercise_dir="$LEARNING_DIR/data_exercises"
      mkdir -p "$exercise_dir"
      sudo chown -R "$user:$user" "$exercise_dir"
      {
        for i in {1..100}; do
          echo "$(shuf -e "${fruits[@]}" | head -n $((RANDOM % 5 + 5)) | tr '\n' ',' | sed 's/,$//')"
        done
      } > "$exercise_dir/fruit_list.txt"

      # Generate a names.csv file with 20 random entries
      first_names=("John" "Jane" "Alice" "Bob" "Charlie" "Dana" "Eve" "Frank" "Grace" "Hank" "Ivy" "Jack" "Kate" "Leo" "Mia" "Nina" "Oscar" "Paula" "Quinn" "Ryan")
      last_names=("Smith" "Johnson" "Williams" "Brown" "Jones" "Garcia" "Martinez" "Lee" "Taylor" "Hernandez" "Lopez" "Gonzalez" "Wilson" "Anderson" "Thomas" "Moore" "Jackson" "Martin" "White" "Thompson")

      {
        for i in {1..20}; do
          first_name="${first_names[$RANDOM % ${#first_names[@]}]}"
          last_name="${last_names[$RANDOM % ${#last_names[@]}]}"
          echo "$first_name,$last_name"
        done
      } > "$exercise_dir/names.csv"

      echo "Data for exercises created in $exercise_dir."
      ;;

    
    2)
      privilege_exercises="$LEARNING_DIR/privileges_exercises"
      mkdir -p "$privilege_exercises"
      sudo chown -R "$user:$user" "$privilege_exercises"      
      echo -e "The credentials that have been created for this exercise are:\nuser1:password\nuser2:password\nuser3:password" >"$privilege_exercises/user_credentials.txt"
      # Create users for privilege exercises
      sudo useradd user1 && echo "user1:password" | sudo chpasswd
      sudo useradd user2 && echo "user2:password" | sudo chpasswd
      sudo useradd user3 && echo "user3:password" | sudo chpasswd
      sudo bash -c 'echo "user1 ALL=(ALL) ALL" >> /etc/sudoers'
      sudo bash -c 'echo "user2 ALL=(ALL) /bin/ls, /bin/cat" >> /etc/sudoers'
      sudo bash -c 'echo "user3 ALL=(ALL) NOPASSWD: /bin/nano" >> /etc/sudoers'
      echo "Privilege users created with varying access."
      echo "Credentials can be found in the privilege_exercises folder"
      ;;
    
    3)
      # Delete users for privilege exercises
      sudo userdel -r user1
      sudo userdel -r user2
      sudo userdel -r user3
      echo "Privilege users deleted."
      mkdir  
      ;;
    
    4)
      # Create files for permissions exercises
      PERMISSIONS_DIR="$LEARNING_DIR/permissions"
      mkdir -p "$PERMISSIONS_DIR"
      sudo chown -R "$user:$user" "$PERMISSIONS_DIR"      
      touch "$PERMISSIONS_DIR/read_only.txt"
      touch "$PERMISSIONS_DIR/no_access.txt"
      sudo chown "$SUDO_USER:$SUDO_USER" "$PERMISSIONS_DIR/read_only.txt"
      chmod 400 "$PERMISSIONS_DIR/read_only.txt"
      chmod 000 "$PERMISSIONS_DIR/no_access.txt"
      echo "can you add text to this file?" > "$PERMISSIONS_DIR/read_only.txt"
      echo "well done you have accessed the file" > "$PERMISSIONS_DIR/no_access.txt"
      echo "Permissions exercise files created in $PERMISSIONS_DIR."
      ;;
    
    5)
      # Create files for compression exercises
      COMPRESSION_DIR="$LEARNING_DIR/compression"
      mkdir -p "$COMPRESSION_DIR"
      sudo chown -R "$user:$user" "$COMPRESSION_DIR"
      # Create uncompressed files
      echo "you have extracted file 1" > "$COMPRESSION_DIR/uncompressed1.txt"
      echo "you have extracted file 2" > "$COMPRESSION_DIR/uncompressed2.txt"
      echo "you have extracted file 3" > "$COMPRESSION_DIR/uncompressed3.txt"

      # Compress files
      tar -czf "$COMPRESSION_DIR/compressed1.tar.gz" -C "$COMPRESSION_DIR" uncompressed1.txt
      zip "$COMPRESSION_DIR/compressed2.zip" "$COMPRESSION_DIR/uncompressed2.txt"
      gzip -c "$COMPRESSION_DIR/uncompressed3.txt" > "$COMPRESSION_DIR/compressed3.gz"

      # Delete the uncompressed files after compression
      rm "$COMPRESSION_DIR/uncompressed1.txt"
      rm "$COMPRESSION_DIR/uncompressed2.txt"
      rm "$COMPRESSION_DIR/uncompressed3.txt"

      echo "Compression exercises created in $COMPRESSION_DIR. Uncompressed files deleted."
      ;;
    
    6)
      # Create files for finding files exercise
      FINDING_DIR="$LEARNING_DIR/finding_files"
      mkdir -p "$FINDING_DIR"
      sudo chown -R "$user:$user" "$FINDING_DIR"      
      echo -e "Your task is to find the following files:\nfile1.txt\nfile2.csv\nfile3.log" > "$FINDING_DIR/find_me.txt"
      echo "Congrats, you found me!" > "$LEARNING_DIR/file1.txt"
      echo "Congrats, you found me!" > "$LEARNING_DIR/file2.csv"
      echo "Congrats, you found me!" > "$LEARNING_DIR/file3.log"

      # Randomly place files in different locations
      sudo mv "$LEARNING_DIR/file1.txt" /tmp/file1.txt
      sudo mv "$LEARNING_DIR/file2.csv" /opt/file2.csv
      sudo mv "$LEARNING_DIR/file3.log" /var/log/file3.log

      echo "The files you need to find are documented in $FINDING_DIR."
      ;;

7)
# Function to create Docker container with SSH enabled for SCP exercise
create_docker_container() {
    echo "Creating Docker container with SSH for SCP exercise..."
    
    # Check if the Docker network exists, if not, create it
    if ! docker network inspect ssh_network > /dev/null 2>&1; then
        echo "Creating Docker network..."
        docker network create ssh_network
    fi
    
    # Build Docker container
    echo "Building Docker container..."
    docker build -t ssh-container .
    
    # Start the Docker container
    echo "Starting Docker container..."
    docker run -d --network ssh_network --name ssh_container ssh-container
    
    # Wait for the container to initialize
    sleep 2
    
    # Check if the container is running
    if ! docker ps --filter "name=ssh_container" > /dev/null; then
        echo "Docker container failed to start."
        exit 1
    fi
    
    # Get the container's IP address
    container_ip=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ssh_container)

    # Display connection info
    echo -e "\033[1;32mDocker container created with SSH enabled. Connect with:\033[0m"
    echo -e "\033[1;37m  ssh root@$container_ip\033[0m"
    echo -e "\033[1;37m  Password: password\033[0m"
    echo -e "\033[1;37mTo practice SCP, use: scp <file> root@$container_ip:/root\033[0m"
}

# Function to remove Docker container and network
remove_docker_container() {
    echo "Removing Docker container and network..."
    
    # Stop and remove the Docker container
    docker stop ssh_container
    docker rm ssh_container
    
    # Remove the Docker network
    docker network rm ssh_network
}
create_docker_container
  ;;

    
    0)
      # Exit with data deletion confirmation
      echo "Do you want to delete all data from this tool? (Y/N)"
      read -r confirm
      if [[ $confirm == "Y" || $confirm == "y" ]]; then
        rm -rf "$LEARNING_DIR"
       remove_docker_container
      rm /tmp/file1.txt
      rm /opt/file2.csv
      rm /var/log/file3.log
      sudo userdel -r user1
      sudo userdel -r user2
      sudo userdel -r user3
      sudo sed -i '/user1 ALL=(ALL) ALL/d' /etc/sudoers
      sudo sed -i '/user2 ALL=(ALL) \/bin\/ls, \/bin\/cat/d' /etc/sudoers
      sudo sed -i '/user3 ALL=(ALL) NOPASSWD: \/bin\/nano/d' /etc/sudoers
      echo "privilege users deleted"

        echo "All exercise data, docker containers deleted. Exiting."
      else
        echo "Exiting without deleting data."
      fi
      exit 0
      ;;
    
    *)
      echo -e "\033[1;31mInvalid option, please try again.\033[0m"
      ;;
  esac
done

