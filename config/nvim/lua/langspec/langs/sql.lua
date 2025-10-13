return {
	packages = { "sqlfluff" },
	parsers = { "sql" },
	linters = { sql = { "sqlfluff" } },
	formatters = { sql = { "sqlfluff" } },
}
