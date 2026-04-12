return {
	packages = { "terraform", "terraform-ls", "tflint", "tfsec" },
	parsers = { "terraform" },
	linters = { terraform = { "tflint", "tfsec" } },
	formatters = { terraform = { "terraform_fmt" } },
	language_servers = { "terraformls" },
}
