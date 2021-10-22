##################################################################################
# PROVIDERS
##################################################################################

provider vra {
  url           = var.vra_url
  refresh_token = var.vra_api_token
}

##################################################################################
# DATA
##################################################################################

data "vra_region" "aws-us-west-1" {
  cloud_account_id = vra_cloud_account_aws.this.id
  region           = "us-west-1"
}

data "vra_region" "aws-us-west-2" {
  cloud_account_id = vra_cloud_account_aws.this.id
  region           = "us-west-2"
}

data "vra_region" "aws-us-east-1" {
  cloud_account_id = vra_cloud_account_aws.this.id
  region           = "us-east-1"
}

data "vra_region" "aws-us-east-2" {
  cloud_account_id = vra_cloud_account_aws.this.id
  region           = "us-east-2"
}

##################################################################################
# RESOURCES
##################################################################################

# Create the Cloud Accounts for Amazon Web Services in VMware Cloud Assembly.

resource "vra_cloud_account_aws" "this" {
  name        = var.aws_name
  description = var.aws_description
  access_key  = var.aws_access_key
  secret_key  = var.aws_secret_key
  regions     = var.aws_regions
  tags {
    key   = "cloud"
    value = "aws"
  }
}

# Create the Cloud Zones for Amazon Web Services in VMware Cloud Assembly.

resource "vra_zone" "aws-us-west-1" {
  name        = "aws-us-west-1"
  description = "Amazon Web Services Cloud Zone Configured by Terraform"
  region_id   = data.vra_region.aws-us-west-1.id
  tags {
    key   = "region"
    value = "west"
  }
}

resource "vra_zone" "aws-us-west-2" {
  name        = "aws-us-west-2"
  description = "Amazon Web Services Cloud Zone Configured by Terraform"
  region_id   = data.vra_region.aws-us-west-2.id
  tags {
    key   = "region"
    value = "west"
  }
}

resource "vra_zone" "aws-us-east-1" {
  name        = "aws-us-east-1"
  description = "Amazon Web Services Cloud Zone Configured by Terraform"
  region_id   = data.vra_region.aws-us-east-1.id
  tags {
    key   = "region"
    value = "east"
  }
}

resource "vra_zone" "aws-us-east-2" {
  name        = "aws-us-east-2"
  description = "VMware Cloud Foundation Cloud Zone Configured by Terraform"
  region_id   = data.vra_region.aws-us-east-2.id
  tags {
    key   = "region"
    value = "east"
  }
}

# Create the flavor mappings for Amazon Web Services in VMware Cloud Assembly.

resource "vra_flavor_profile" "aws-us-west-1" {
  name        = "terraform-flavor-profile"
  description = "Amazon Web Services Flavor Mappings Created by Terraform"
  region_id   = data.vra_region.aws-us-west-1.id
  flavor_mapping {
    name          = "x-small"
    instance_type = "t2.micro"
  }
  flavor_mapping {
    name          = "small"
    instance_type = "t2.small"
  }
  flavor_mapping {
    name          = "medium"
    instance_type = "t2.medium"
  }
  flavor_mapping {
    name          = "large"
    instance_type = "t2.large"
  }
}

resource "vra_flavor_profile" "aws-us-west-2" {
  name        = "terraform-flavor-profile"
  description = "Amazon Web Services Flavor Mappings Created by Terraform"
  region_id   = data.vra_region.aws-us-west-2.id
  flavor_mapping {
    name          = "x-small"
    instance_type = "t2.micro"
  }
  flavor_mapping {
    name          = "small"
    instance_type = "t2.small"
  }
  flavor_mapping {
    name          = "medium"
    instance_type = "t2.medium"
  }
  flavor_mapping {
    name          = "large"
    instance_type = "t2.large"
  }
}

resource "vra_flavor_profile" "aws-us-east-1" {
  name        = "terraform-flavor-profile"
  description = "Amazon Web Services Flavor Mappings Created by Terraform"
  region_id   = data.vra_region.aws-us-east-1.id
  flavor_mapping {
    name          = "x-small"
    instance_type = "t2.micro"
  }
  flavor_mapping {
    name          = "small"
    instance_type = "t2.small"
  }
  flavor_mapping {
    name          = "medium"
    instance_type = "t2.medium"
  }
  flavor_mapping {
    name          = "large"
    instance_type = "t2.large"
  }
}

resource "vra_flavor_profile" "aws-us-east-2" {
  name        = "terraform-flavor-profile"
  description = "Amazon Web Services Flavor Mappings Created by Terraform"
  region_id   = data.vra_region.aws-us-east-2.id
  flavor_mapping {
    name          = "x-small"
    instance_type = "t2.micro"
  }
  flavor_mapping {
    name          = "small"
    instance_type = "t2.small"
  }
  flavor_mapping {
    name          = "medium"
    instance_type = "t2.medium"
  }
  flavor_mapping {
    name          = "large"
    instance_type = "t2.large"
  }
}

# Create the image mappings for Amazon Web Services in VMware Cloud Assembly.

resource "vra_image_profile" "aws-us-west-1" {
  name        = "terraform-aws-image-profile"
  description = "Amazon Web Services Image Mappings Created by Terraform"
  region_id   = data.vra_region.aws-us-west-1.id

  image_mapping {
    name       = "ubuntu-server-focal-20-04-lts"
    image_name = "ami-0dd655843c87b6930"
  }
  image_mapping {
    name       = "ubuntu-server-eoan-19-10"
    image_name = "ami-0dd655843c87b6930"
  }
  image_mapping {
    name       = "ubuntu-server-bionic-18-04-lts"
    image_name = "ami-0dd655843c87b6930"
  }
}

resource "vra_image_profile" "aws-us-west-2" {
  name        = "terraform-aws-image-profile"
  description = "Amazon Web Services Image Mappings Created by Terraform"
  region_id   = data.vra_region.aws-us-west-2.id

  image_mapping {
    name       = "ubuntu-server-focal-20-04-lts"
    image_name = "ami-0dd655843c87b6930"
  }
  image_mapping {
    name       = "ubuntu-server-eoan-19-10"
    image_name = "ami-0dd655843c87b6930"
  }
  image_mapping {
    name       = "ubuntu-server-bionic-18-04-lts"
    image_name = "ami-0dd655843c87b6930"
  }
}

resource "vra_image_profile" "aws-us-east-1" {
  name        = "terraform-aws-image-profile"
  description = "Amazon Web Services Image Mappings Created by Terraform"
  region_id   = data.vra_region.aws-us-east-1.id

  image_mapping {
    name       = "ubuntu-server-focal-20-04-lts"
    image_name = "ami-0dd655843c87b6930"
  }
  image_mapping {
    name       = "ubuntu-server-eoan-19-10"
    image_name = "ami-0dd655843c87b6930"
  }
  image_mapping {
    name       = "ubuntu-server-bionic-18-04-lts"
    image_name = "ami-0dd655843c87b6930"
  }
}

resource "vra_image_profile" "aws-us-east-2" {
  name        = "terraform-aws-image-profile"
  description = "Amazon Web Services Image Mappings Created by Terraform"
  region_id   = data.vra_region.aws-us-east-2.id

  image_mapping {
    name       = "ubuntu-server-focal-20-04-lts"
    image_name = "ami-0dd655843c87b6930"
  }
  image_mapping {
    name       = "ubuntu-server-eoan-19-10"
    image_name = "ami-0dd655843c87b6930"
  }
  image_mapping {
    name       = "ubuntu-server-bionic-18-04-lts"
    image_name = "ami-0dd655843c87b6930"
  }
}

# Create project to consume Amazon Web Services in VMware Cloud Assembly.

resource "vra_project" "sample" {
  name              = "Terraform Sample Project"
  description       = "Project Configured by Terraform"
  operation_timeout = 6000
  administrators    = ["johnsonryan@vmware.com"]
  members           = ["gblake@vmware.com"]

  zone_assignments {
    zone_id       = vra_zone.aws-us-west-1.id
    priority      = 1
    max_instances = 0
  }
  zone_assignments {
    zone_id       = vra_zone.aws-us-west-2.id
    priority      = 1
    max_instances = 0
  }
  zone_assignments {
    zone_id       = vra_zone.aws-us-east-1.id
    priority      = 1
    max_instances = 0
  }
  zone_assignments {
    zone_id       = vra_zone.aws-us-east-2.id
    priority      = 1
    max_instances = 0
  }
}