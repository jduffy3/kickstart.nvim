return {
  'vim-test/vim-test',
  vim.keymap.set('n', '<leader>t', ':TestNearest<CR>', { desc = '[T]est nearest' }),
  vim.keymap.set('n', '<leader>T', ':TestFile<CR>', { desc = '[T]est file' }),
  vim.keymap.set('n', '<leader>a', ':TestSuite<CR>', { desc = '[T]est suite' }),
  vim.keymap.set('n', '<leader>g', ':TestVisit<CR>', { desc = '[T]est visit' }),
}
