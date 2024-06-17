Getting Started
---------------

### Introduction
This is a demo project for education/training purposes.

It automates (using **Terraform**) the provisioning of the following resources in Akamai 
Connected Cloud (former Linode):
- **Object Storage**: S3 compliant object storage.
- **Linode**: Compute instance.

It also mounts the Object Storage bucket in a volume using S3FS.

Please check the files `iac/linode*.tf` for more details.

All the Terraform files use `variables` that are stored in the `iac/variables.tf` and `iac/settings.json`.

You can change the attributes of the provisioning by editing these files. 

### Documentation

Follow the documentation below to know more about Akamai:

- [**How to create Akamai Connected Cloud credentials**](https://www.linode.com/docs/api)
- [**How to create an Object Storage**](https://www.linode.com/docs/guides/platform/object-storage)
- [**List of Akamai Connected Cloud Regions**](https://www.linode.com/docs/api/regions/)
- [**Akamai Connected Cloud Documentation**](https://www.linode.com/docs/)

### Important notes
- **DON'T EXPOSE OR COMMIT ANY SENSITIVE DATA, SUCH AS CREDENTIALS, IN THE PROJECT.**

### Contact
**LinkedIn:**
- https://www.linkedin.com/in/fvilarinho

**e-Mail:**
- fvilarin@akamai.com
- fvilarinho@gmail.com
- fvilarinho@outlook.com
- me@vila.net.br

and that's all! Have fun!
