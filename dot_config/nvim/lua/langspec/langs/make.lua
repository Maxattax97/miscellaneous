return {
	packages = {
		"language-server-bitbake",
		"neocmakelsp",
	},
	parsers = { "make", "bitbake", "cmake", "meson", "ninja" },
	language_servers = { "bitbake_language_server", "neocmake" },
}
