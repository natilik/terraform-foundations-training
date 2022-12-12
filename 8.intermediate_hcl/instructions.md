# Lab Part 1 - Data Types, Functions and Locals

1. Navigate to the “8.intermediate_hcl” directory and select the relevant cloud sub-directory.

2. Your aws_s3_bucket/azurerm_storage_account resource is referencing a local for its name – complete the configuration of the local. You need to create a name that:
  * Has a prefix that is the result of the random_string resource.
  * Has a suffix of the value that is provided by var.student_name.
    * e.g. awfiauvnau-mike-guy (Hint: a bit of string interpolation should help you here!)
  * Note: The random provider doesn’t guarantee uniqueness – it is possible you could get an apply-time error. Pick any value for the variable “environment” – this will come into play in a bit. If you’re on Azure, you’ll have a bit more work to do as well due to naming restrictions (max characters and no dashes permitted).

3. All seems good with your code, but you have realised users can provide their name in upper or camel-case. You want it all lower case. Is there a function that could help you fix this? Implement a fix and test it works as expected.

4. You decide you want to apply some common tags to your bucket/storage account as well as a custom name tag. By modifying only the resource – find a function that can help merge the two together.

5. You have noticed users have been using an input data type you didn’t expect for var.environment. Apply a suitable type constraint to the “environment” variable to ensure it can only ever be a string.

6. Change the length value under the random_string resource to use a variable instead of a hardcoded value. Use a validation block and a suitable function to ensure the value provided is between 10 and 5. A placeholder has been created (commented out) in variables.tf to get you started.

7. Don’t destroy your resources – we will use them in the second part of the lab coming up soon. You are finished for now.




# Lab Part 2 - Loops, Expressions and Dynamics

1. Using the same lab as we did in part 1, we’re going to make some changes.

2. Change the bucket/storage account resource to create two resources instead using whichever of the looping constructs you prefer – loop or for_each. Don’t forget to ensure the relevant values are unique. 

3. Using the commented out additional_bucket/additional_storage_account resource, uncomment and make it work, but make this a conditional resource (i.e. a variable determines if it is created). 
  * There is a variable ready to be used in variables.tf – it just needs uncommenting. Make the condition you use work with this variable and then test out enabling/disabling it.

4. Configure either of the buckets/storage accounts to use a dynamic block of type “cors_rule”. There is a variable commented out in variables.tf and a cors.tfvars input file you can use. Make it work with these.
  * Note: Whilst this will work and is great for what we need here, it is being deprecated in AWS (you’ll see a warning). Always check the documentation and ensure you’re using the recommended approach.
  * Use the following docs to assist you if you:
    * https://developer.hashicorp.com/terraform/language/expressions/dynamic-blocks
    * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
    * https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account 

5. Clean up your environment with a destroy.
