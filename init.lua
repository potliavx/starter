-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- VJ's config
vim.opt.tabstop = 4
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

local non_c_line_comments_by_filetype = {
    lua = "--",
    python = "#",
    sql = "--",
}

local function comment_out(opts)
    local line_comment = non_c_line_comments_by_filetype[vim.bo.filetype] or "//"
    local start = math.min(opts.line1, opts.line2)
    local finish = math.max(opts.line1, opts.line2)

    vim.api.nvim_command(start .. "," .. finish .. "s:^:" .. line_comment .. ":")
    vim.api.nvim_command("noh")
end

local function uncomment(opts)
    local line_comment = non_c_line_comments_by_filetype[vim.bo.filetype] or "//"
    local start = math.min(opts.line1, opts.line2)
    local finish = math.max(opts.line1, opts.line2)

    pcall(vim.api.nvim_command, start .. "," .. finish .. "s:^\\(\\s\\{-\\}\\)" .. line_comment .. ":\\1:")
    vim.api.nvim_command("noh")
end

vim.api.nvim_create_user_command("CommentOut", comment_out, { range = true })
vim.keymap.set("v", "<leader>co", ":CommentOut<CR>")
vim.keymap.set("n", "<leader>co", ":CommentOut<CR>")

vim.api.nvim_create_user_command("Uncomment", uncomment, { range = true })
vim.keymap.set("v", "<leader>uc", ":Uncomment<CR>")
vim.keymap.set("n", "<leader>uc", ":Uncomment<CR>")


local cmp = require("cmp")
cmp.setup({
    enabled = function()
      -- disable completion in comments
      local context = require 'cmp.config.context'
      -- keep command mode completion enabled when cursor is in a comment
      if vim.api.nvim_get_mode().mode == 'c' then
        return true
      else
        return not context.in_treesitter_capture("comment")
          and not context.in_syntax_group("Comment")
      end
    end
})
-- cmp.setup {
--     enabled = function()
--         -- disable completion if the cursor is `Comment` syntax group.
--         return not cmp.config.context.in_syntax_group('Comment')
--     end
-- }
