local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight when yanking (copying) text
autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Auto-reload files changed externally (passive awareness for agent workflow)
autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
	desc = "Auto-reload files changed externally",
	group = augroup("auto-reload", { clear = true }),
	callback = function()
		if vim.o.buftype ~= "nofile" then
			vim.cmd("checktime")
		end
	end,
})

-- Disable autoread prompts - trust external changes
vim.o.autoread = true

-- Large file handling (>1MB): disable treesitter and LSP for performance
autocmd("BufReadPre", {
	desc = "Large file handling",
	group = augroup("large-file", { clear = true }),
	callback = function(args)
		local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
		if ok and stats and stats.size > 1024 * 1024 then
			vim.b[args.buf].large_file = true
			vim.cmd("syntax off")
			vim.opt_local.foldmethod = "manual"
			vim.opt_local.spell = false
			vim.opt_local.swapfile = false
			vim.opt_local.undofile = false
			vim.opt_local.breakindent = false
			vim.opt_local.colorcolumn = ""
			vim.opt_local.statuscolumn = ""
			vim.opt_local.signcolumn = "no"
			vim.schedule(function()
				vim.bo[args.buf].syntax = ""
			end)
		end
	end,
})

-- Disable treesitter for large files
autocmd("FileType", {
	desc = "Disable treesitter for large files",
	group = augroup("large-file-treesitter", { clear = true }),
	callback = function(args)
		if vim.b[args.buf].large_file then
			pcall(function()
				vim.treesitter.stop(args.buf)
			end)
		end
	end,
})

-- Binary file handling - warn before opening
autocmd("BufReadCmd", {
	desc = "Warn before opening binary files",
	group = augroup("binary-file", { clear = true }),
	pattern = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.bmp", "*.ico", "*.pdf", "*.zip", "*.tar", "*.gz", "*.exe", "*.dll", "*.so", "*.dylib", "*.docx", "*.xlsx", "*.pptx" },
	callback = function(args)
		local name = vim.api.nvim_buf_get_name(args.buf)
		local choice = vim.fn.confirm("'" .. vim.fn.fnamemodify(name, ":t") .. "' is a binary file. Open anyway?", "&Yes\n&No", 2)
		if choice == 1 then
			vim.cmd("doautocmd BufReadPre")
			vim.cmd("read " .. vim.fn.fnameescape(name))
			vim.cmd("1delete_")
			vim.bo[args.buf].modifiable = false
			vim.bo[args.buf].readonly = true
		else
			vim.api.nvim_buf_delete(args.buf, { force = true })
		end
	end,
})


