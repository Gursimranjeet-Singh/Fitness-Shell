#!/bin/bash

# File to store fitness data
FITNESS_LOG="fitness_log.txt"
MEAL_FILE="meal_data.txt"
GOAL_FILE="fitness_goals.txt"

# Function to display the dashboard
display_dashboard() {
  dashboard_text="Fitness Dashboard\n\n"
  
  # Display daily or weekly summary
  dashboard_text+="Summary (Last 7 days):\n"
  daily_summary=$(grep "$(date -d '7 days ago' +%F)" "$FITNESS_LOG" | awk -F, '{total_calories+=$2; total_burned+=$3} END {print "Calories Consumed: " total_calories " kcal\nCalories Burned: " total_burned " kcal"}')
  dashboard_text+="$daily_summary\n\n"
  
  # Display progress towards fitness goals
  dashboard_text+="Fitness Goals:\n"
  if [ -s "$GOAL_FILE" ]; then
    fitness_goals=$(awk -F, '{print $2, $4 " / " $3 " units"}' "$GOAL_FILE")
  else
    fitness_goals="No fitness goals found."
  fi
  dashboard_text+="$fitness_goals"

  # Display the dashboard using dialog
  dialog --title "Fitness Dashboard" --msgbox "$dashboard_text" 20 80
}

# Function to generate a basic report
generate_report() {
  clear
  echo "Fitness Report"
  echo "--------------"
  
  # Display exercise routines
  echo -e "\nExercise Routines:"
  echo "------------------"
  if [ -s "$FITNESS_LOG" ]; then
    grep "Exercise Added" "$FITNESS_LOG" | awk -F, '{print $1, $4, "sets x", $5, "reps x", $6, "weight"}'
  else
    echo "No exercise routines found."
  fi
  
  # Display meal log
  echo -e "\nMeal Log:"
  echo "---------"
  if [ -s "$MEAL_FILE" ]; then
    cat "$MEAL_FILE" | column -t -s ','
  else
    echo "No meals found."
  fi
}

# Function to add an exercise routine
add_exercise() {
  exercise_time=$(dialog --inputbox "Enter exercise time (YYYY-MM-DD HH:MM:SS):" 8 40 --stdout)
  sets=$(dialog --inputbox "Enter number of sets:" 8 40 --stdout)
  reps=$(dialog --inputbox "Enter number of reps:" 8 40 --stdout)
  weight=$(dialog --inputbox "Enter weight used (lbs):" 8 40 --stdout)

  echo "$exercise_time,Exercise Added,$sets,$reps,$weight" >> "$FITNESS_LOG"
  dialog --msgbox "Exercise routine added successfully." 8 40
}

# Function to log a meal
log_meal() {
  meal_time=$(dialog --inputbox "Enter meal time (YYYY-MM-DD HH:MM:SS):" 8 40 --stdout)
  meal_name=$(dialog --inputbox "Enter meal name:" 8 40 --stdout)
  calories=$(dialog --inputbox "Enter calories consumed:" 8 40 --stdout)

  echo "$meal_time,Meal Logged,$meal_name,$calories kcal" >> "$MEAL_FILE"
  dialog --msgbox "Meal logged successfully." 8 40
}

# Main function
main() {
  while true; do
    choice=$(dialog --menu "Fitness Tracking Menu" 15 40 5 \
            1 "Display Dashboard" \
            2 "Generate Report" \
            3 "Add Exercise Routine" \
            4 "Log Meal" \
            5 "Exit" --stdout)

    case $choice in
      1)
        display_dashboard
        ;;
      2)
        generate_report
        ;;
      3)
        add_exercise
        ;;
      4)
        log_meal
        ;;
      5)
        dialog --msgbox "Exiting Fitness Tracking. Goodbye!" 8 40
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
