return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				tailwindcss = {
					filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "html", "css", "svelte" },
					-- Pour Tailwind v4, ajoute ici des settings spécifiques si besoin
				},
				cssls = {
					filetypes = { "css", "scss", "less" },
				},
			},
		},
	},
}
