#!/bin/bash

main() {
  while true; do
    choice=$(dialog --menu "Glad You are here!! Please Select service" 15 40 4 \
            1 "Dashboard" \
            2 "My Fitness" \
            3 "My Meal" \
            4 "Show Reminders" \
            5 "Exit" --stdout)

    # If the user clicks OK or presses Enter
    if [ $? -eq 0 ]; then
      case $choice in
        1)
          ./dashboard.sh
          ;;
        2)
          ./fitness.sh
          ;;
        3)
          ./meal.sh
          ;;
        4)
          ./reminder.sh
          ;;
        5)
          dialog --msgbox "Goodbye!" 8 40
          exit 0
          ;;
        *)
          echo "Invalid choice. Please try again."
          ;;
      esac
    fi
  done
}

# Call the main function
main
