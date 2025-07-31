#!/usr/bin/env python3
import json
import subprocess
import tempfile
import os

# Get Terraform output
tf_output = subprocess.run(["terraform", "output", "-json"], capture_output=True, text=True, cwd="../terraform")
outputs = json.loads(tf_output.stdout)

ip = outputs["vm_ip"]["value"]
private_key = outputs["private_key"]["value"]

# Save the private key to a temporary file
key_file = tempfile.NamedTemporaryFile(delete=False, mode='w', prefix="ansible_", suffix=".pem")
key_file.write(private_key)
key_file.close()

# Ensure correct file permissions
os.chmod(key_file.name, 0o600)

# Create Ansible inventory JSON
inventory = {
    "all": {
        "hosts": [ip],
        "vars": {
            "ansible_user": "azureuser",
            "ansible_ssh_private_key_file": key_file.name
        }
    }
}

print(json.dumps(inventory))
