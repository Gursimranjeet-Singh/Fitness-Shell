#!/bin/bash

# File to store user data
USER_DATA_FILE="user_data.txt"

# Function to register a new user
register_user() {
  username=$(dialog --inputbox "Enter a username:" 8 40 --stdout)
  password=$(dialog --passwordbox "Enter a password:" 8 40 --stdout)
  echo "$username:$password" >> "$USER_DATA_FILE"
  dialog --msgbox "User registered successfully." 8 40
}

# Function to authenticate a user
authenticate_user() {
  entered_username=$(dialog --inputbox "Enter your username:" 8 40 --stdout)
  entered_password=$(dialog --passwordbox "Enter your password:" 8 40 --stdout)
  echo

  # Check if the entered credentials match any user in the file
  if grep -q "^$entered_username:$entered_password$" "$USER_DATA_FILE"; then
    dialog --msgbox "Authentication successful. Welcome, $entered_username!" 8 40
    ./feature_navigate.sh
  else
    dialog --msgbox "Authentication failed. Invalid username or password." 8 40
  fi
}

# Main function
main() {
  while true; do
    choice=$(dialog --menu "User Authentication Menu" 15 40 3 \
            1 "Register User" \
            2 "Authenticate User" \
            3 "Exit" --stdout)

    case $choice in
      1)
        register_user
        ;;
      2)
        authenticate_user
        ;;
      3)
        dialog --msgbox "Exiting User Authentication. Goodbye!" 8 40
        exit 0
        ;;
      *)
        dialog --msgbox "Invalid choice. Please enter a valid option." 8 40
        ;;
    esac
  done
}

# Execute the main function
main
