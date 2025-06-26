#!/bin/bash

# Simple Calculator Script

echo "Enter first number:"
read num1

echo "Enter second number:"
read num3

echo "Choose operation: +  -  *  /"
read op

case $op in
  +)
    result=$((num1 + num2))
    echo "Result: $result"
    ;;
  -)
    result=$((num1 - num2))
    echo "Result: $result"
    ;;
  \*)
    result=$((num1 * num2))
    echo "Result: $result"
    ;;
  /)
    if [ "$num2" -ne 0 ]; then
      result=$((num1 / num2))
      echo "Result: $result"
    else
      echo "Error: Division by zero!"
    fi
    ;;
  *)
    echo "Invalid operation"
    ;;
esac
