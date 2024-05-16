#!/bin/bash

current_dir=$(basename $(pwd))

echo "This script will create a GitHub repository named '$current_dir'."
echo "The remote named 'origin' will be added  and your code will be pushed."
read -p "Are you sure you want to continue? (y/n) " confirmation


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
  remote_url="$gh_repo_create_output"

  # Check if the remote URL was retrieved successfully
  if [[ -z "$remote_url" ]]; then
    echo "Failed to retrieve remote URL for '$current_dir'."
    exit 1
  fi

  git remote add origin "$remote_url.git"
  git push

else
  echo "Aborting..."
  read -p "Would you like to create a repository with a custom name? (y/n) " custom_name_prompt

  if [[ "$custom_name_prompt" =~ ^[Yy]$ ]]; then
    # Get custom name from user
    read -p "Enter your desired repository name: " custom_name

    # Create the repository with the custom name
    gh repo create "$custom_name" &> /dev/null

    # Create the repository on GitHub and Specify remote name directly
    gh_repo_create_output=$(gh repo create "$custom_name" --public)
    remote_url="$gh_repo_create_output"

    # Check if the remote URL was retrieved successfully
    if [[ -z "$remote_url" ]]; then
      echo "Failed to retrieve remote URL for '$current_dir'."
      exit 1
    fi

    git remote add origin "$remote_url.git"
    git push

  else
    echo "No action taken."
  fi
fi