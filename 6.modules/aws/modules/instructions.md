# Lab - Developing Modules

1. We are going to “modularise” the hcl_basics code we previously used in an earlier lab.

2. Navigate to the “6.modules” directory.  You’ll see a bootstrapped framework. Your task is to take the code from your working hcl_basics lab and split it into the relevant bootstrapped modules.

3. Some pointers:
    * Each file contains some comments about what is expected from a resource/data perspective.
    * Think about what you may want users to vary based on inputs – CIDR ranges/names perhaps? Feel free to use whatever you like – as long as you can get it working.
    * Think about any outputs you may need in each module:
      * Does your root need any return values? Hint: it does!
      * Does your call to ec2 depend on any outputs from networking? Hint: it does!
    * If you’re new to Terraform or have not worked with modules before – this may be a bit challenging – don’t be afraid to ask for help or further clarification.

