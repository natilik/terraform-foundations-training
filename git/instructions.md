# Lab Part 1 - Getting Familiar with Git
1. Login to your remote repository of choice (Azure DevOps, GitHub, BitBucket, GitLab etc.) and setup a repository (specifics and terminology may vary by provider).

2. On your local machine, clone the repository using the URL provided in the browser.
Note, authentication approach will vary from provider to provider and whether you made it public or private. If you’re struggling, we can create a public repository for you.

3. Go ahead and create some files, then add then to the staging area/index and create some commits. After creating a commit, review your log to see your history.

4. When you’re ready, push the local repository changes to the remote repository – take a look in the browser. Can you identify the commit history?

5. Once you can see your changes in the remote repository, delete the local folder and re-clone the repository. Note how all your changes and history are still there!

# Lab Part 2 - Branching
1. Using the repository from the previous lab, create a new local branch. Make sure you checkout the new branch if not using one of the “combined” commands.

2. Make some changes to some files, add them and commit them to your new branch.

3. What happens if you checkout or switch back to main/master?

4. Ensure you are back on your new branch and type “git push origin” to try and push the changes to the remote repository. Did you get an error? How can you fix this?

5. Once you’ve completed step four, go through the process of merging this branch into your main/master branch using the remote repositories workflow (varies slightly based on provider).
  * When going through this process, take the time to have a good look around. How do you know what has changed?

6. Once you’ve merged, switch back to main/master on your local repository and ensure you pull any changes. Can you now safely delete the local branch?

# Lab Part 2 - Undoing Mistakes
1. Using the repository from the previous lab, make some changes to a file and save them (do not add or commit them yet). Revert the “erroneous” changes to that file using one of the commands we looked at.

2. Create a new file in your local repository and add it to your staging area. Remove this from your staging area without deleting the file.

3. Make some sort of change it, add it to the staging area and create a commit – do NOT push this yet. You decide there is an error in your commit message – fix just the error message.

4. Once you’ve “fixed” your error in step three, push it to the remote repository. Turns out this broke production and you need to revert the change you made – go ahead and do this. Push to the remote once you’ve fixed the problem.

5. Ensure your local repository is up-to-date with the remote, then go ahead and mess it up as much as you like! Delete files, make bad changes etc. Get yourself back to the last known good state so your working directory matches the remote repository and everything is clean.
