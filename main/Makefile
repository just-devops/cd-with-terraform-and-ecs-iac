# Usage - Define TERRAFORM_VERSION, and include this file as below.
#
#TERRAFORM_VERSION := 1.3
# include Makefile.terraform

# If this variable is not set in your makefile, the program /bin/sh is used as the shell.
# https://www.gnu.org/software/make/manual/html_node/Choosing-the-Shell.html
SHELL := /bin/bash

# This option causes make to display a warning whenever an undefined variable is expanded.
MAKEFLAGS += --warn-undefined-variables

# Disable any builtin pattern rules, then speedup a bit.
MAKEFLAGS += --no-builtin-rules

# Disable any builtin suffix rules, then speedup a bit.
.SUFFIXES:

# The arguments passed to the shell are taken from the variable .SHELLFLAGS.
#
# The -e flag causes bash with qualifications to exit immediately if a command it executes fails.
# The -u flag causes bash to exit with an error message if a variable is accessed without being defined.
# The -o pipefail option causes bash to exit if any of the commands in a pipeline fail.
# The -c flag is in the default value of .SHELLFLAGS and we must preserve it.
# Because it is how make passes the script to be executed to bash.
.SHELLFLAGS := -eu -o pipefail -c

# Sets the default goal to be used if no targets were specified on the command line.
.DEFAULT_GOAL := help

# https://gist.github.com/tadashi-aikawa/da73d277a3c1ec6767ed48d1335900f3
.PHONY: $(shell grep --no-filename -E '^[a-zA-Z0-9_-]+:' $(MAKEFILE_LIST) | sed 's/://')

define terraform
	run_dir="${1}" && \
	sub_command="${2}" && \
	option="${3}" && \
	terraform $${sub_command} $${option}
endef


tf_format:
	$(call terraform,.,fmt,-recursive)

tf_validate:
	$(call terraform,.,validate)

tf_plan:
	$(call terraform,.,plan,-out=current-tf-plan.dot)

plan: tf_format tf_validate tf_plan

apply:
	$(call terraform,.,apply,-auto-approve)

destroy:
	$(call terraform,.,destroy,-auto-approve)

main: tf_format tf_validate tf_plan apply

reset: destroy tf_format tf_validate tf_plan apply main
