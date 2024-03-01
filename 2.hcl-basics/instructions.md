# Lab - HCL Basics 

1. Navigate to the “2.hcl-basics” directory and select the relevant cloud sub-directory (aws or azure). Be sure to change location in your terminal using the “cd” command.

2. Login and configure your AWS or Azure CLI to point to a suitable non-production environment:
  * Azure – “az login” and “az account set –subscription <sub_name>”
  * AWS – “aws configure [sso]” (SSO if required – select appropriate roles etc.).

3. Review the code in main.tf file to get familiar with what will be deployed. There is a missing line of code (search for # REPLACE_ME) that you need to fix before it will apply successfully – fix it!

4. Make sure you review your plan to ensure you become familiar with the outputs. Once applied successfully, can you connect to the VM using the command shown on the terminal? Try and identify the terraform code that generated this output.

5. Now you’ve built the infrastructure, try out the different ways you could provide values for the variable inputs.

6. The code is currently hard-coding the value for the VM size (instance type on AWS/size on Azure). Can you change this to a variable and still get it working?

7. Run a destroy command once you’ve finished – ensure all expected resources are deleted.

