#!/bin/bash
set -e
set -o nounset 

readonly CURRENT_PWD="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
cd $CURRENT_PWD

sops -d -i ./tfstate/terraform.tfstate

find . -name 'secrets.tfvars' | xargs -I {} bash -ce "sops -d -i {}"