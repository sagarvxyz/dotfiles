# Git functions

function git_branch_delete_matching() {
	if [ -z "$1" ]; then
		echo "Usage: git_branch_delete_matching <pattern>"
		return 1
	fi

	targets=$(git branch | grep $1)
	if [ -z "$targets" ]; then
		echo "No branches found matching '$1'"
		return 1
	fi

	git branch -d $targets
}

function git_branch_clean() {
  # Fetch the latest changes from the remote
  git fetch --prune

  # Get a list of local branches that have no upstream
  local branches_to_delete=$(git branch -vv | awk '/: gone]/{print \$1}')

  # Iterate over each branch and delete it
  for branch in $branches_to_delete; do
    echo "Deleting branch: $branch"
    git branch -d $branch
  done
}