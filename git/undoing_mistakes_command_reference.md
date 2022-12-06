* “I added a file to the staging area that I didn’t mean to.”
  * git rm --cached <filename> - unstage the file – the file contents will not change.

* “I accidentally deleted a file that had already been committed previously.”
  * git checkout HEAD <filename>

* “I made some changes to a file which I didn’t mean to. I’ve not added the file to staging yet.”
  * git restore <filename> - discard the changes in your working directory.

* “I made some changes to a file which I didn’t mean to. I’ve staged the changes but have not yet committed.”
  * git restore --staged <filename> - unstage the change (working directory still changed).
    * Follow with the first command to then discard changes in working directory.

* “I screwed up my commit message, but have not yet pushed to the remote.”
  * git commit --amend – fix the last commit message. Local use only.

* “I screwed up more than just the commit message – I included a bunch of changes I didn’t mean to.”
  * git reset <sha> – move your “pointers” back to the <sha> commit. Local use only.
    * --hard – affects your head pointer, staging area and working directory. All are reset.
    * --mixed – (default) move your pointers and update your staging area. Working directory remains as it is.
    * --soft – move your pointers. Staging and working directory remain as they are.

* “I’ve made a load of changes I didn’t meant to – it’s a mess. I just want to restore everything back to the last commit.”
  * git reset --hard – use with caution! This can cause you to lose work.

* “I committed and pushed broken code. It is public, so not I can’t just use git reset. Help!”
  * git revert <sha> – create a new commit that reverses back to the state that was in <sha>.
