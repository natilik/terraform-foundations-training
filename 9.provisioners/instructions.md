# Lab - Provisioners

1. Navigate to the “9.provisioners” directory and the relevant cloud sub-directory. Be sure to change location in your terminal with the “cd” command.

2. Here we have added a “connection” block to the VM – take a look over the configuration.

3. Add a new file provisioner to the virtual machine/aws_instance and run a terraform apply. The details to use are:
content – this should use the templatefile function to load “./files/index.html.tmpl” and populate the appropriate variables. 
  * Hint: don’t forget you have access to the “self” object to retrieve what you need.
destination – this file should be written to “/home/ubuntu/index.html” on the destination server.

4. Our website doesn’t work yet as our file is in the wrong location on the target server. We will now use a remote-exec provisioner to move it to the correct location. The code for this has already been provided – you just need to uncomment it out.
  * Note: An apply alone isn’t enough to re-deploy this resource as provisioners run once at creation time! Use the –replace=“<address>” for force a rebuild.
  * Watch the terminal output during the rebuild to see how it behaves and not the info you see streamed. Note how you see output from the inline script we provided.

5. At this point, a basic website should now be operational. Try accessing it using the URL provided in the http_url output.

6. Finally, let’s add a local-exec provisioner. Configure one under the same resource. It should run the script located in “./files/Invoke-TcpCheck.ps1”. The script requires two flags to be provided (shown below). Again, the self-object coupled with some string interpolation will help you get what you need.
-PublicIP
-FileName

7. Take a look at the output of your script. Finally, clean up your resources with a “terraform destroy”.
