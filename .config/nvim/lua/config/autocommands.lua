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

-- Binary file handling
autocmd("BufReadPost", {
	desc = "Binary file handling",
	group = augroup("binary-file", { clear = true }),
	callback = function(args)
		local name = vim.api.nvim_buf_get_name(args.buf)
		local binary_extensions = { "%.png$", "%.jpg$", "%.jpeg$", "%.gif$", "%.bmp$", "%.ico$", "%.pdf$", "%.zip$", "%.tar$", "%.gz$", "%.exe$", "%.dll$", "%.so$", "%.dylib$" }
		for _, ext in ipairs(binary_extensions) do
			if name:match(ext) then
				vim.bo[args.buf].modifiable = false
				vim.bo[args.buf].readonly = true
				vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, { "[Binary file]" })
				return
			end
		end
	end,
})

-- Auto-close unused buffers (aggressive buffer cleanup)
autocmd("BufHidden", {
	desc = "Auto-close unused buffers",
	group = augroup("buffer-cleanup", { clear = true }),
	callback = function(args)
		if vim.bo[args.buf].buftype == "" and not vim.bo[args.buf].modified then
			vim.schedule(function()
				if vim.api.nvim_buf_is_valid(args.buf) and not vim.bo[args.buf].modified then
					local wins = vim.fn.win_findbuf(args.buf)
					if #wins == 0 then
						pcall(vim.api.nvim_buf_delete, args.buf, { force = false })
					end
				end
			end)
		end
	end,
})
