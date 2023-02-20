# Lab - Developing Modules

1. We are going to turn some previous code into re-usable modules. Navigate to the “6.modules” directory and your chosen cloud sub-directory. Be sure to change location in your terminal using the “cd” command.

2. You’ll see previous code has been broken into two modules – “aws_ec2” and “aws_networking” (or “azure_vm” and “azure_networking” for Azure).

3. Have a look at the main.tf under the “root-code” directory. There are a few things to populate:

  * The variable inputs to each module need to be populated under their respective module block.
  * The value assigned to the root-level output called “vm_public_ip” needs to be populated.

4. Ensure your infrastructure deploys ok with a “terraform apply”.

5. The VM/instance size is currently hardcoded in the module. Change this so it is exposed to the root as a variable.

6. We still have no root-level variables defined, resulting in duplicate hard-coded values for student name. Change student-name to be a variable at the root-level and update all references.

7. Once complete, clean-up with a “terraform destroy”.
