import requests
import json
from requests.auth import HTTPBasicAuth

# Set up Prism Central credentials and URL
prism_central_ip = "prism_central_ip_or_url"
username = "your_username"
password = "your_password"

# Set up the API endpoint URL
api_url = f"https://{prism_central_ip}:9440/api/nutanix/v3/ipam_pools/list"

# Disable SSL warnings (not recommended for production)
requests.packages.urllib3.disable_warnings(requests.packages.urllib3.exceptions.InsecureRequestWarning)

# Fetch IPAM pools
response = requests.post(api_url, auth=HTTPBasicAuth(username, password), verify=False)

if response.status_code == 200:
    ipam_pools = response.json()
    # Parse and print IPAM pool details
    for pool in ipam_pools['entities']:
        print(f"IPAM Pool Name: {pool['spec']['name']}")
        print(f"IP Range: {pool['spec']['resources']['subnet_reference']['range']}")
        print("---------------------------------------------------")
else:
    print(f"Failed to fetch IPAM pools. Status Code: {response.status_code}, Response: {response.text}")
