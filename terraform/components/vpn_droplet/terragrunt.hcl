# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "local"
  config = {
    path = "${get_parent_terragrunt_dir()}/../../tfstate/terraform.tfstate"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}


terraform {
  extra_arguments "secrets_tfvars" {
    commands = ["apply", "plan", "destroy"]

    # required_var_files = [
    #   "${get_parent_terragrunt_dir()}/terraform.tfvars"
    # ]

    # optional_var_files = [
    required_var_files = [
      "${get_parent_terragrunt_dir()}/secrets.tfvars",
    ]
  }

  extra_arguments "auto_approve_apply" {
    commands = ["apply", "destroy"]
    arguments = [
      "-auto-approve"
    ]
  }

}