#!/bin/bash

# File to store meal data
MEAL_FILE="meal_data.txt"

# File to store fitness data
FITNESS_FILE="fitness_data.txt"

# File to store fitness goals
GOAL_FILE="fitness_goals.txt"

# File to store user data
USER_DATA_FILE="user_data.txt"

# Function to set a reminder message
set_reminder() {
  reminder_message=$(dialog --inputbox "Enter reminder message:" 8 40 --stdout)
  dialog --msgbox "Reminder message set: $reminder_message" 8 40
}

# Function to schedule a reminder
schedule_reminder() {
  scheduled_time=$(dialog --inputbox "Enter scheduled time (HH:MM):" 8 40 --stdout)
  dialog --msgbox "Reminder scheduled for $scheduled_time" 8 40
  # Here you would add code to schedule the reminder using 'at' or any other method
}

# Function to add a new meal
add_meal() {
  meal_name=$(dialog --inputbox "Meal Name:" 8 40 --stdout)
  calories=$(dialog --inputbox "Calories:" 8 40 --stdout)
  proteins=$(dialog --inputbox "Proteins (g):" 8 40 --stdout)
  carbohydrates=$(dialog --inputbox "Carbohydrates (g):" 8 40 --stdout)
  fats=$(dialog --inputbox "Fats (g):" 8 40 --stdout)
  time_of_consumption=$(dialog --inputbox "Time of Consumption (HH:MM):" 8 40 --stdout)

  echo "$meal_name,$calories,$proteins,$carbohydrates,$fats,$time_of_consumption" >> "$MEAL_FILE"
  dialog --msgbox "Meal added successfully." 8 40
}

# Function to view all meals
view_meals() {
  if [ -s "$MEAL_FILE" ]; then
    dialog --title "Meal Log" --textbox "$MEAL_FILE" 20 80
  else
    dialog --title "Meal Log" --msgbox "No meals found." 8 40
  fi
}

# Function to edit a meal
edit_meal() {
  view_meals
  meal_number=$(dialog --inputbox "Enter the meal number to edit:" 8 40 --stdout)
  edited_data=$(dialog --inputbox "Enter the new meal data (Meal Name, Calories, Proteins, Carbohydrates, Fats, Time of Consumption):" 8 100 --stdout)

  sed -i "${meal_number}s/.*/$edited_data/" "$MEAL_FILE"
  dialog --msgbox "Meal edited successfully." 8 40
}

# Function to delete a meal
delete_meal() {
  view_meals
  meal_number=$(dialog --inputbox "Enter the meal number to delete:" 8 40 --stdout)

  sed -i "${meal_number}d" "$MEAL_FILE"
  dialog --msgbox "Meal deleted successfully." 8 40
}

# Function to add fitness data
add_fitness_data() {
  exercise_name=$(dialog --inputbox "Enter exercise name:" 8 40 --stdout)
  sets=$(dialog --inputbox "Enter sets:" 8 40 --stdout)
  reps=$(dialog --inputbox "Enter reps:" 8 40 --stdout)
  weight=$(dialog --inputbox "Enter weight (lbs):" 8 40 --stdout)

  echo "$(date "+%Y-%m-%d %H:%M:%S"),$exercise_name,$sets,$reps,$weight" >> "$FITNESS_FILE"
  dialog --msgbox "Fitness data added successfully." 8 40
}

# Function to view fitness data
view_fitness_data() {
  if [ -s "$FITNESS_FILE" ]; then
    dialog --title "Fitness Data" --textbox "$FITNESS_FILE" 20 80
  else
    dialog --title "Fitness Data" --msgbox "No fitness data found." 8 40
  fi
}

# Function to remove an exercise from the list
remove_exercise() {
  exercises=$(awk -F',' '{print $2}' "$FITNESS_FILE")
  IFS=$'\n' read -r -d '' -a exercises_array <<< "$exercises"

  exercise_to_remove=$(dialog --menu "Select Exercise to Remove" 20 80 10 "${exercises_array[@]}" --stdout)

  if [ -z "$exercise_to_remove" ]; then
    dialog --msgbox "No exercise selected for removal." 8 40
    return
  fi

  dialog --yesno "Are you sure you want to remove '$exercise_to_remove' from the list?" 8 40

  if [ $? -eq 0 ]; then
    sed -i "/$exercise_to_remove/d" "$FITNESS_FILE"
    dialog --msgbox "Exercise '$exercise_to_remove' removed successfully." 8 40
  else
    dialog --msgbox "Removal canceled." 8 40
  fi
}

# Function to set a new fitness goal
set_fitness_goal() {
  goal_type=$(dialog --inputbox "Goal Type (e.g., Weight Loss, Muscle Gain, Specific Achievement):" 8 40 --stdout)
  goal_description=$(dialog --inputbox "Goal Description:" 8 40 --stdout)
  target_value=$(dialog --inputbox "Target Value:" 8 40 --stdout)

  echo "$goal_type,$goal_description,$target_value,0" >> "$GOAL_FILE"
  dialog --msgbox "Fitness goal set successfully." 8 40
}

# Function to view all fitness goals
view_fitness_goals() {
  if [ -s "$GOAL_FILE" ]; then
    dialog --title "Fitness Goals" --textbox "$GOAL_FILE" 20 80
  else
    dialog --title "Fitness Goals" --msgbox "No fitness goals found." 8 40
  fi
}

# Function to update progress towards a fitness goal
update_fitness_progress() {
  goals=$(awk -F',' '{print $2}' "$GOAL_FILE")
  IFS=$'\n' read -r -d '' -a goals_array <<< "$goals"

  goal_number=$(dialog --menu "Select Goal to Update Progress" 20 80 10 "${goals_array[@]}" --stdout)

  current_progress=$(awk -F, -v goal_number="$goal_number" 'NR==goal_number {print $4}' "$GOAL_FILE")

  new_progress=$(dialog --inputbox "Enter current progress (numeric value):" 8 40 --stdout)
  sed -i "${goal_number}s/$current_progress/$new_progress/" "$GOAL_FILE"
  dialog --msgbox "Progress updated successfully." 8 40
}

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
    # Call the main menu function if authentication is successful
    main_menu
  else
    dialog --msgbox "Authentication failed. Invalid username or password." 8 40
  fi
}

# Main menu function
main_menu() {
  while true; do
    choice=$(dialog --menu "Main Menu" 20 60 10 \
            1 "Set Reminder Message" \
            2 "Schedule Reminder" \
            3 "Add Meal" \
            4 "View Meals" \
            5 "Edit Meal" \
            6 "Delete Meal" \
            7 "Log Fitness Data" \
            8 "View Fitness Data" \
            9 "Remove Exercise" \
            10 "Set Fitness Goal" \
            11 "View Fitness Goals" \
            12 "Update Fitness Progress" \
            13 "Exit" --stdout)

    case $choice in
      1) set_reminder ;;
      2) schedule_reminder ;;
      3) add_meal ;;
      4) view_meals ;;
      5) edit_meal ;;
      6) delete_meal ;;
      7) add_fitness_data ;;
      8) view_fitness_data ;;
      9) remove_exercise ;;
      10) set_fitness_goal ;;
      11) view_fitness_goals ;;
      12) update_fitness_progress ;;
      13)
        dialog --msgbox "Exiting. Goodbye!" 8 40
        exit 0 ;;
      *) dialog --msgbox "Invalid choice. Please enter a valid option." 8 40 ;;
    esac
  done
}

# Authentication menu function
authentication_menu() {
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

# Execute the authentication menu function
authentication_menu
