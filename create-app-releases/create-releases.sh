#!/bin/sh

gum style \
 --border normal --margin "1" --padding "1 2" --border-foreground 212 \
 "Let's create some $(gum style --foreground 212 'Releases')." \
 "Please enter the application to create releases for and the associated deployment-configurations repo." \
 "" \
 "When you are finished reviewing the output, run step 2, CleanUp, to delete the releases, tags, and PRs in deployment-configurations." \
 "Finally, Exit this tool"

APP_REPO=$(gum input --placeholder "owner/app-repo")
DEP_CONF_REPO=$(gum input --placeholder "owner/deployment-configurations-repo")

# generate releases with random prefix and desired, incrementing tags
createReleases() {
    RELEASE_COUNT=$(gum input --placeholder "Number of releases to create")
    RELEASE_PREFIX=$(cat /dev/urandom | tr -dc 'a-z' | fold -w ${1:-5} | head -n 1)
    for i in $(seq 1 $RELEASE_COUNT)
    do
        release_tag="$RELEASE_PREFIX.$i"
        gh release create "$release_tag" --repo $APP_REPO --title "$release_tag" --notes "$release_tag"
    done
}

listPrs() {
    echo
    gh pr list --repo "$DEP_CONF_REPO" --state open --json headRefName,title --jq '.[] | select(.title | contains("'"$RELEASE_PREFIX"'")) | .headRefName' | while read -r branch; do
        echo "$branch"
    done
}

closePrs(){
    gh pr list --repo "$DEP_CONF_REPO" --state open --json number,title --jq '.[] | select(.title | contains("'"$RELEASE_PREFIX"'")) | "\(.number) \(.title)"' | while IFS=' ' read -r pr_number pr_title; do
        gh pr close "$pr_number" --repo "$DEP_CONF_REPO"
    done
}

deleteBranches() {
    gh pr list --repo "$DEP_CONF_REPO" --state closed --json headRefName,title --jq '.[] | select(.title | contains("'"$RELEASE_PREFIX"'")) | .headRefName' | while read -r branch; do
        git push origin --delete "$branch"
    done
}

listReleases() {
    echo
    gh release list --repo "$APP_REPO" --limit 100 | grep "\b$RELEASE_PREFIX.\b" | while read -r line; do
        tag_name=$(echo "$line" | awk '{print $1}')

        echo "$tag_name"
    done
}

deleteReleasesAndTags() {
    gh release list --repo "$APP_REPO" --limit 100 | grep "\b$RELEASE_PREFIX.\b" | while read -r line; do
        tag_name=$(echo "$line" | awk '{print $1}')

        gh release delete "$tag_name" -y --repo "$APP_REPO"

        git tag -d "$tag_name"
        git push --delete origin "$tag_name"
    done
}


cleanUp() {
    temp_dir=$(mktemp -d)
    trap "rm -rf $temp_dir" EXIT

    cd "$temp_dir"


    if gum confirm "Do you want to clean up open PRs and delete branches, releases, and tags created by this tool?"; then
        gh repo clone $DEP_CONF_REPO > /dev/null 2>&1 && cd ${DEP_CONF_REPO#*/}
        if gum confirm "Confirm closing of PRs and deletion of the following Branches:$(listPrs)"; then
            closePrs
            deleteBranches
            cd .. && rm -rf ${DEP_CONF_REPO#*/}
        else
            echo "PR deletion cancelled, try another command or exit"
            cd .. && rm -rf ${DEP_CONF_REPO#*/}
        fi
        gh repo clone $APP_REPO > /dev/null 2>&1 && cd ${APP_REPO#*/}
        if gum confirm "Confirm deletion of the following releases and tags:$(listReleases)"; then
            deleteReleasesAndTags
            cd .. && rm -rf ${APP_REPO#*/}
        else
            echo "Release and Tag deletion cancelled, try another command or exit"
            cd .. && rm -rf ${APP_REPO#*/}
        fi
    else
        echo "Cancelled cleanup, try another command or exit"
    fi
}


while true; do
    cmd=$(gum choose "1:CreateReleases" "2:CleanUp" "Exit")

    for choice in $cmd; do
        case $choice in
            "1:CreateReleases")
                echo "How many relases would you like to create in $APP_REPO?"
                createReleases
                ;;
            "2:CleanUp")
                echo "Deleting branches, releases, and tags created."
                cleanUp
                ;;
            "Exit")
                echo "Exiting."
                exit 0
                ;;
            *)
                echo "Invalid option: $choice. Please try again."
                ;;
        esac
    done
done
