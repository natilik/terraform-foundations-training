# Lab Part 1 - Data Types, Functions and Locals

1. Navigate to the “8.intermediate_hcl” directory and select the relevant cloud sub-directory. Be sure to change location in your terminal using the “cd” command.

2. Your aws_s3_bucket (AWS) or azurerm_storage_account (Azure) resource is referencing a local for its name – complete the configuration placeholder (# Fill me in) so that you create a name that:
  * Has a prefix that is the result of the random_string resource.
  * Has a suffix of the value that is provided by var.student_name.
    * e.g. awfiauvnaumikeguy (Hint: a bit of string interpolation “${}” should help you here!)
  * Note: The random provider doesn’t guarantee uniqueness – it is possible you could get an apply-time error. Pick any value for the variable “environment” – this will come into play in a bit. 

3. Ensure your code deploys with a Terraform apply.

4. All seems good with your code, but you have realised users can provide their name in upper or camel-case. You want it all lower case. Is there a function that could help you fix this? Implement a fix and test it works as expected.

5. You decide you want to apply some common tags to your bucket/storage account as well as a custom name tag. By modifying only the values provided to the tags setting, find a function that can help merge the two together.

6. You have noticed you aren’t applying a type constraint on the environment variable. Configure a suitable type constraint.

7. The length setting under the random_string resource is currently hardcoded. Move this to using a variable instead.

8. Don’t destroy your resources – we will use them in the second part of the lab coming up soon. You are finished for now.



# Lab Part 2 - Loops, Expressions and Dynamics

1. Using the same lab as we did in part 1, we’re going to make some changes.

2. Change the bucket/storage account resource so that it creates multiple instances using whichever of the approaches you prefer – count or for_each. Don’t forget to ensure the relevant values are unique. 

3. There is a commented-out resource at the bottom of main.tf. Uncomment and make it work, but make this a conditional resource (i.e. a variable determines if it is created). 
  * There is a variable ready to be used in variables.tf – it just needs uncommenting. Make the condition you use work with this variable and then test out enabling/disabling it.

4. Configure either of the buckets/storage accounts to use a dynamic block of type “cors_rule” (for the Azure resource, this is nested under a blob_properties block). There is a variable commented out in variables.tf and a cors.tfvars input file you can use. Make it work with these.
  * Note: Whilst this will work and is great for what we need here, it is being deprecated in AWS (you’ll see a warning). Always check the documentation and ensure you’re using the recommended approach.
  * Use the following docs to assist you if you:
    * https://developer.hashicorp.com/terraform/language/expressions/dynamic-blocks
    * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
    * https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account 

5. Clean up your environment with a destroy.

