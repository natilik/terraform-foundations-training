# Lab - HCL Basics

1. Navigate to the “2.hcl-basics” directory and select the relevant cloud sub-directory.

2. Login and configure your AWS or Azure CLI to point to a suitable non-production environment:
  * Azure – “az login” and “az account set –subscription <sub_name>”
  * AWS – “aws configure [sso]” (SSO if required – select appropriate roles etc.).

3. Review the code and use your knowledge so far to understand and deploy what has been defined! There is a missing line of code (search for # REPLACE_ME) – can you fix it using a resource reference? Once this is fixed, you’ll be able to deploy the code.

4. Try out different ways of providing variable inputs. 

5. Make sure you review your plan to ensure it is building what you expect. Can you connect to the VM after it has been built? How did you know what details to use?

6. At the moment we are hard-coding the value for the VM size (instance type on AWS/size on Azure). Can you change this to a variable and get it working?

7. Run a destroy command once you’ve finished – ensure all expected resources are deleted.

