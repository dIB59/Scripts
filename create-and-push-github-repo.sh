#!/bin/bash

current_dir=$(basename $(pwd))

echo "This script will create a GitHub repository named '$current_dir'."
echo "The remote named 'origin' will be added (if it doesn't exist) and your code will be pushed."
read -p "Are you sure you want to continue? (y/n) " confirmation

# Check if the repository exists (optional)


if [[ "$confirmation" =~ ^[Yy]$ ]]; then

  # Check if the GitHub CLI (gh) is installed
  if ! command -v gh &> /dev/null; then
    echo "GitHub CLI (gh) is required to run this script."
    echo "Please install it and try again."
    exit 1
  fi

  # Check if the current directory is already a Git repository
  if ! git rev-parse --is-inside-work-tree &> /dev/null; then
    echo "This directory is not a Git repository."
    echo "Please initialize a Git repository and try again."
    exit 1
  fi

  # Create the repository on GitHub and Specify remote name directly
  gh_repo_create_output=$(gh repo create "$current_dir" --public)
  postfix= ".git"
  echo "---------------------------------"
  echo "$gh_repo_create_output"
  echo "---------------------------------"
  remote_url="$gh_repo_create_output$postfix"
  
  echo "---------------------------------"
  echo "Remote URL: $remote_url"
  echo "---------------------------------"

  # Check if the remote URL was retrieved successfully
  if [[ -z "$remote_url" ]]; then
    echo "Failed to retrieve remote URL for '$current_dir'."
    exit 1
  fi

  # Add the remote named "origin" (if it doesn't exist)
  git remote add origin "$remote_url.git"

  # Push your code to the remote repository (origin main)
  git push
else
  echo "Aborting..."
  read -p "Would you like to create a repository with a custom name? (y/n) " custom_name_prompt

  if [[ "$custom_name_prompt" =~ ^[Yy]$ ]]; then
    # Get custom name from user
    read -p "Enter your desired repository name: " custom_name

    # Create the repository with the custom name
    gh repo create "$custom_name" &> /dev/null

    # ... (remaining script logic for adding remote and pushing using the custom_name)

  else
    echo "No action taken."
  fi
fi