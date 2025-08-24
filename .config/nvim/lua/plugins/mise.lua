return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.treesitter.query.add_predicate("is-mise?", function(match, pattern, source, predicate, metadata)
        local filename = vim.api.nvim_buf_get_name(source)
        return filename:match("mise%.toml$") ~= nil
      end, { force = true })
    end,
  },
}
