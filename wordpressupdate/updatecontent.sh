#!/bin/bash

cd /workspaces/glueops

# Repository and branch parameters
NEW_BRANCH="AntonBilyk-patch-1"
FILE_PATH="index.html" # Change the file path if necessary

# Clone a repository using the GitHub CLI
gh repo clone example-tenant/wordpress
cd wordpress

# Enter new content on the page
read -p "Enter new content for the page " NEW_TEXT

# File editing
sed -i "26s|<h1>.*</h1>|<h1>${NEW_TEXT}</h1>|" $FILE_PATH

# Creating a new branch, commit, and push
git checkout -b $NEW_BRANCH
git add $FILE_PATH
git commit -m "Update index.html"
git push --set-upstream origin $NEW_BRANCH

# Creating a Pull Request through GitHub CLI and getting the URL
PR_URL=$(gh pr create --title "Update text in index.html" --body "QA step" --base main --head $NEW_BRANCH)

# Outputting the Pull Request URL
echo "Follow next link to check PR bot: $PR_URL"

# Pausing the script and asking whether to continue
read -p "Have you completed all checks and wish to continue? (All input combinations except of "yes" will terminate the script) " answer
if [ "$answer" != "yes" ]; then
    echo "Script stopped."
    exit 1
fi

# Merging the Pull Request
PR_NUMBER=$(basename "$PR_URL")
gh pr merge $PR_NUMBER --merge -d
echo "Pull Request #${PR_NUMBER} is successfully merged and ${NEW_BRANCH} is deleted"

# Instruct the user to wait for GitHub Actions to complete
echo "Please follow https://github.com/example-tenant/wordpress/actions to ensure the completion of GitHub Actions."

# Wait for user input to continue
read -n 1 -s -r -p "Press any key to continue after confirming that all actions have completed successfully."

# Continue with the rest of the script
echo "Continuing script..."

# Comparing values
echo "Compare the new tag from the last GlueOps bot message here (https://github.com/example-tenant/deployment-configurations) with the last commit tag here (https://github.com/example-tenant/wordpress) "

# Wait for user input to continue
read -n 1 -s -r -p "Press any key to continue in the case when tags are the same"

# Continue with the rest of the script
echo "Continuing script..."

# Unset TAG_NAME in case it was set in a previous run
unset TAG_NAME

# Prompt the user to enter a tag name
while true; do
    read -p "Enter the tag name for the release: " TAG_NAME
    if [ -n "$TAG_NAME" ]; then
        break
    else
        echo "Tag name cannot be empty. Please enter a valid tag name."
    fi
done

# Create a new tag
git tag $TAG_NAME

# Push the tag to the remote repository
git push origin $TAG_NAME

# Create a release using GitHub CLI
gh release create $TAG_NAME --title "$TAG_NAME" --target main

# Output the result
echo "Release $TAG_NAME created with tag $TAG_NAME"

# Instruct the user to wait for GitHub Actions to complete
echo "Please follow https://github.com/example-tenant/wordpress/actions to ensure the completion of GitHub Actions."

# Wait for user input to continue
read -n 1 -s -r -p "Press any key to continue after confirming that all actions have completed successfully."

cd ../deployment-configurations

git fetch

git pull

# Get 2 latest PR in deployment-configurations repo
PR_IDS=$(gh pr list --limit 2 --state open --json number -q '.[].number')
PR_ID_ARRAY=($PR_IDS)

# Check if two PRs are found
if [ ${#PR_ID_ARRAY[@]} -eq 2 ]; then
    # Merging the first PR
    gh pr merge ${PR_ID_ARRAY[0]} --merge --delete-branch

    # Merging the second PR
    gh pr merge ${PR_ID_ARRAY[1]} --merge --delete-branch
else
    echo "Not found exactly two PRs."
    exit 1
fi

# Returning to the initial directory
cd ..
