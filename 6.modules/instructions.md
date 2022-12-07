# Lab - Developing Modules

1. We are going to “modularise” the hcl_basics code we previously used in an earlier lab.

2. Navigate to the “6.modules” directory.  You’ll see previous code has been broken into two modules – “aws_ec2” and “aws_networking” (or “azure_vm” and “azure_networking” for Azure).

3. Have a look at the main.tf under the “root-code” directory. There are a few things to populate:

  * The variable inputs to each module need to be populated under their respective module block.
  * The value assigned to the root-level output called “vm_public_ip” needs to be populated.

4. The VM/instance size is currently hardcoded in the module. Change this so it is exposed to the root as a variable.

5. We still have no root-level variables defined, resulting in duplicate hard-coded values for student name. Change student-name to be a variable at the root-level and update all references.
