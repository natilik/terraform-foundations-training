# Lab - Versioning

1. Navigate to the “7.versioning” directory and select the relevant cloud sub-directory.
    * Note: You’ll need to be on Windows for this lab to work as expected.

2. Your colleague has defined some Terraform resources that they want to create, but they didn’t check the documentation. The old provider version in use doesn’t have all the resources defined. Try an init/plan/apply to see.

3. Fix the issues in the directory so that the resource successfully deploys. Ensure it deploys with a terraform apply.
    * Do this without manually deleting any files.
    * Use a “pessimistic versioning” constraint for the version string.

4. Destroy the infrastructure you just created with a “terraform destroy”.

5. Check the version of terraform you are running, then deliberately set a version constraint to a newer value than you are using. Re-run the plan/apply process and note any error messages (just for familiarisation).



