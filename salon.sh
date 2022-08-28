#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t -c"

echo -e "\n~~ Welcome to my salon ! ~~\n"

MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  # Show services provided
  echo -e "\nSelect a service !"
  SERVICES=$($PSQL "SELECT * FROM services")
  echo "$SERVICES" | while IFS=" | " read SERVICE_ID NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
  read SERVICE_ID_SELECTED
  # If number not selected
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
    MAIN_MENU "Select a valid number !"
  fi
  
  # If selected service doesn't exist
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  # if [[ -z $SERVICE_NAME ]]
  # then
  #   MAIN_MENU "That service doesn't exist !"
  # fi

  echo -e "\nEnter your phone number !"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nHello new user !\nTell us your name !"
    read CUSTOMER_NAME
    INSERT_RESULT=$($PSQL "INSERT INTO customers (phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  echo -e "\nWhat time would you like your appointment to be !"
  read SERVICE_TIME

  APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  echo -e "\nI have put you down for a"$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")" at $SERVICE_TIME, $CUSTOMER_NAME."
  exit
}

MAIN_MENU