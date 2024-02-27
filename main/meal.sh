#!/bin/bash

# File to store meal data
MEAL_FILE="meal_data.txt"

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

# Main function
main() {
  while true; do
    choice=$(dialog --menu "Meal Tracker Menu" 15 40 5 \
            1 "Add Meal" \
            2 "View Meals" \
            3 "Edit Meal" \
            4 "Delete Meal" \
            5 "Exit" --stdout)

    case $choice in
      1)
        add_meal
        ;;
      2)
        view_meals
        ;;
      3)
        edit_meal
        ;;
      4)
        delete_meal
        ;;
      5)
        dialog --msgbox "Exiting Meal Tracker. Goodbye!" 8 40
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
