# Lab - Providers

1. Navigate to the “5.providers” directory and select the relevant cloud sub-directory. Be sure to change location in your terminal using the “cd” command.

2. One provider block has already been setup for you – you need to create a second provider block to target a different area of the respective cloud:
  * AWS – create an additional block targeting the region of “eu-west-2”.
  * Azure – create an additional provider block targeting a second subscription. 
    * Note: You’ll also need to populate the place holder for the <primary_subscription_id> as this was not known in advance.

3. As well as the additional provider block, you’ll need to make a change to some of code. Fix the following resources to deploy as expected:
  * AWS – “aws_s3_bucket.eu_west_2_bucket”.
  * Azure – “azurerm_resource_group.secondary_subscription” and “azurerm_storage_account.secondary_account”.

4. Once you’re happy the code is right, run a “terraform apply” to deploy the resources:
  * Note: the random_string provider doesn’t guarantee we will get a unique, unused name. You may hit an error on apply. Have a think about how you can deal with this if it crops up.

5. Once the resources have been created, review them in the relevant console to ensure they are in the correct subscription/region.

6. Destroy all resources once you’ve finished the steps above.
