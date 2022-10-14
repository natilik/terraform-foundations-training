# Lab - Providers

1. Navigate to the “5.providers” directory (same repo) and select the relevant cloud sub-directory.

2. The configuration is not currently restricting the AWS provider version – constrain it to the exact version of “4.29.0” (before running “terraform init”).

3. We have the aws provider block set to “eu-west-1”, but we want one of our resources to be deployed to eu-west-2. Create an additional provider block that will take care of this.

4. As well as the additional provider block, you’ll need to make a change to one of the resource definitions. Fix the aws_s3_bucket resource that has the label “eu_west_2_bucket”.

5. Once you’re happy the above is in place, run a “terraform apply” to deploy the resources:
    * Note: the random_string provider doesn’t guarantee we will get a unique, unused bucket name. You may hit an error on apply. Have a think about how you can deal with this.

6. Once you’re resources have been created, review them in the AWS Console GUI to ensure the regions are as you expect.

7. Destroy all resources once you’ve finished the steps above.


