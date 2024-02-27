#!/bin/bash

# Log file for user activities
LOG_FILE="fitness_log.txt"

# Data file for fitness-related data
DATA_FILE="fitness_data.txt"

# Function to log user activities
log_activity() {
  echo "$(date "+%Y-%m-%d %H:%M:%S") - $1" >> "$LOG_FILE"
}

# Function to add fitness data
add_fitness_data() {
  exercise_name=$(dialog --inputbox "Enter exercise name:" 8 40 --stdout)
  sets=$(dialog --inputbox "Enter sets:" 8 40 --stdout)
  reps=$(dialog --inputbox "Enter reps:" 8 40 --stdout)
  weight=$(dialog --inputbox "Enter weight (lbs):" 8 40 --stdout)

  echo "$(date "+%Y-%m-%d %H:%M:%S"),$exercise_name,$sets,$reps,$weight" >> "$DATA_FILE"
  dialog --msgbox "Fitness data added successfully." 8 40
}

# Function to view fitness data
view_fitness_data() {
  if [ -s "$DATA_FILE" ]; then
    dialog --title "Fitness Data" --textbox "$DATA_FILE" 20 80
  else
    dialog --title "Fitness Data" --msgbox "No fitness data found." 8 40
  fi
}

# Function to remove an exercise from the list
remove_exercise() {
  exercises=$(awk -F',' '{print $2}' "$DATA_FILE")
  IFS=$'\n' read -r -d '' -a exercises_array <<< "$exercises"

  exercise_to_remove=$(dialog --menu "Select Exercise to Remove" 20 80 10 "${exercises_array[@]}" --stdout)

  if [ -z "$exercise_to_remove" ]; then
    dialog --msgbox "No exercise selected for removal." 8 40
    return
  fi

  dialog --yesno "Are you sure you want to remove '$exercise_to_remove' from the list?" 8 40

  if [ $? -eq 0 ]; then
    sed -i "/$exercise_to_remove/d" "$DATA_FILE"
    dialog --msgbox "Exercise '$exercise_to_remove' removed successfully." 8 40
  else
    dialog --msgbox "Removal canceled." 8 40
  fi
}

# Main function
main() {
  log_activity "Script Started"

  while true; do
    choice=$(dialog --menu "Fitness Tracking Menu" 15 40 4 \
            1 "Log Fitness Data" \
            2 "View Fitness Data" \
            3 "Remove Exercise" \
            4 "Fitness Goals"\
            5 "Exit" --stdout)

    case $choice in
      1)
        add_fitness_data
        log_activity "Fitness Data Added"
        ;;
      2)
        view_fitness_data
        log_activity "Viewed Fitness Data"
        ;;
      3)
        remove_exercise
        log_activity "Removed Exercise"
        ;;
      4)
        ./fitnessgoal.sh
        ;;  
      5)
        log_activity "Script Exited"
        dialog --msgbox "Exiting Fitness Tracker. Goodbye!" 8 40
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
