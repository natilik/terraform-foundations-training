# Lab - Providers

1. Navigate to the “5.providers” directory and select the relevant cloud sub-directory. The configuration is not currently restricting the provider version – constrain it to the exact version shown below before running terraform init:
  * AWS – 4.29.0
  * Azure – 3.34.0

2. One provider block has been setup for you, you need to create a second to target a different area of the respective cloud:
  * AWS – create an additional block targeting the region of “eu-west-1”.
  * Azure – create an additional provider block targeting a second subscription. 
    * Note: You’ll also need to populate the place holder for the <primary_subscription_id> as this was not known in advance.

3. As well as the additional provider block, you’ll need to make a change to some code. Fix the following resources to deploy as expected:
  * AWS – “aws_s3_bucket.eu_west_2_bucket”.
  * Azure – “azurerm_resource_group.primary_subscription” and “azurerm_storage_account.secondary_account”.

4. Once you’re happy the code is right, run a “terraform apply” to deploy the resources:
  * Note: the random_string provider doesn’t guarantee we will get a unique, unused name. You may hit an error on apply. Have a think about how you can deal with this if it crops up.

5. Once the resources have been created, review them in the relevant console to ensure they are in the correct subscription/region.

6. Destroy all resources once you’ve finished the steps above.

