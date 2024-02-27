#!/bin/bash

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

# Main function
main() {
  while true; do
    choice=$(dialog --menu "Reminders and Notifications Menu" 15 40 3 \
            1 "Set Reminder Message" \
            2 "Schedule Reminder" \
            3 "Exit" --stdout)

    case $choice in
      1)
        set_reminder
        ;;
      2)
        schedule_reminder
        ;;
      3)
        dialog --msgbox "Exiting Reminders and Notifications. Goodbye!" 8 40
        exit 0
        ;;
      *)
        dialog --msgbox "Invalid choice. Please select a valid option." 8 40
        ;;
    esac
  done
}

# Execute the main function
main
