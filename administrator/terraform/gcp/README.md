# GCP Environment

## Requirements for Ansible and Terraform

### Terraform

You just need to use the google cloud SDK from [here](https://cloud.google.com/sdk/downloads#yum) and then execute those commands in order to get logged by the CLI:
```
gcloud auth login
gcloud auth application-default login
```

Now just it's time to download the modules, fill the variables and execute the plan:
```
terraform init -get -upgrade=true
TF_LOG=DEBUG terraform plan -var-file varfiles/opensouthcode19.tfvars -refresh=true
TF_LOG=DEBUG terraform apply -var-file varfiles/opensouthcode19.tfvars -refresh=true
```

**Note**: Does not work with Terraform 0.12
- https://github.com/terraform-providers/terraform-provider-google/issues/3280

### Ansible

It's a bit complicated but [here it's very well explained](https://devopscube.com/ansible-dymanic-inventry-google-cloud/), I recommend to follow those commands.
```
pip3 install --user apache-libcloud
mkdir -p ~/.ansible/inventory/
wget https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/gce.py -O ~/.ansible/inventory/gce.py
wget https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/gce.ini -O ~/.ansible/inventory/gce.ini
```

Open gce.ini file and configure the following values from the service accout json file. A service account json will look like the following, and save it on _~/.ansible/inventory/gce.json_ . (This is a sample)
```
{
  "type": "service_account",
  "project_id": "devopscube-sandbox",
  "private_key_id": "sdfkjhsadfkjansdf9asdf87eraksd",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBaksdhfjkasdljf sALDIFUHW8klhklSDGKAPISD GIAJDGHIJLSDGJAFSHGJN;MLASDKJHFGHAILFN DGALIJDFHG;ALSDN J Lkhawu8a2 87356801w tljasdbjkh=\n-----END PRIVATE KEY-----\n",
  "client_email": "ansible-provisioning@devopscube-sandbox.iam.gserviceaccount.com",
  "client_id": "32453948568273645823",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://accounts.google.com/o/oauth2/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/ansible-provisioning%40devopscube-sandbox.iam.gserviceaccount.com"
}
```

In **gce.ini** you have to configure the following values.
```
gce_service_account_email_address = ansible-provisioning@devopscube-sandbox.iam.gserviceaccount.com
gce_service_account_pem_file_path = /opt/ansible/service-account.json
gce_project_id = devopscube-sandbox
```

Now use the module:
```
GCE_INI_PATH=~/.ansible/inventory/gce.ini ansible -i ~/.ansible/inventory/gce.py tag_<group_name> -m ping
```

To filter your nodes just apply a tag to them on creation time and just filter the group by the tagname as shows above:
```
GCE_INI_PATH=~/.ansible/inventory/gce.ini ansible -i ~/.ansible/inventory/gce.py tag_kubevirt -m ping

Output:
λ GCE_INI_PATH=~/.ansible/inventory/gce.ini ansible -i ~/.ansible/inventory/gce.py tag_kubevirt -m ping
 [WARNING]: Found both group and host with same name: kubevirt-button-master-build-1

kubevirtlab-1 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
kubevirtlab-2 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```
