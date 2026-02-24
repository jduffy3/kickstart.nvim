-- Only do this when not done yet for this buffer
if vim.fn.exists 'b:did_ftplugin' == 0 then return end
-- let b:did_ftplugin = 1
vim.b.did_ftplugin = 1

local function file_exists(path)
  return path and path ~= '' and vim.loop.fs_stat(path) ~= nil
end

local function build_test_file_path()
  local current = vim.fn.expand '%'

  if current:match('_spec%.rb$') or current:match('_test%.rb$') then
    return current
  end

  if not current:match('%.rb$') then
    return current
  end

  local spec_path
  local test_path

  if current:match('^app/') then
    spec_path = current:gsub('^app/', 'spec/')
    test_path = current:gsub('^app/', 'test/')
  elseif current:match('^lib/') then
    spec_path = current:gsub('^lib/', 'spec/lib/')
    test_path = current
  else
    spec_path = current
    test_path = current
  end

  spec_path = spec_path:gsub('%.rb$', '_spec.rb')
  test_path = test_path:gsub('%.rb$', '_test.rb')

  if file_exists(spec_path) then
    return spec_path
  end

  if file_exists(test_path) then
    return test_path
  end

  return spec_path or test_path or current
end

local function open_test_file(command)
  local test_file = build_test_file_path()
  vim.cmd(string.format('%s %s', command, vim.fn.fnameescape(test_file)))
end

local function run_test_file()
  local test_file = build_test_file_path()
  local escaped = vim.fn.fnameescape(test_file)

  if test_file:match('_spec%.rb$') then
    vim.api.nvim_command(':!bundle exec rspec ' .. escaped)
  else
    vim.api.nvim_command(':!bundle exec rails test ' .. escaped)
  end
end

vim.keymap.set('n', '<leader>rct', function()
  local current_line_number = vim.fn.line '.'
  vim.api.nvim_command(':!bundle exec rails test %' .. ':' .. current_line_number)
end, { desc = '[R]un [C]urrent [T]est' })
vim.keymap.set('n', '<leader>nt', function() vim.api.nvim_command ':/test ' end, { desc = '[N]ext [T]est' })

vim.keymap.set('n', '<leader>tf', function() open_test_file 'edit' end, { desc = 'Open [T]est [F]ile' })
vim.keymap.set('n', '<leader>stf', function() open_test_file 'vsplit' end, { desc = 'Open Vertical [S]plit [T]est [F]ile' })

-- run test from main file or test file
vim.keymap.set('n', '<leader>rt', run_test_file, { desc = '[R]un [T]estfile' })

-- remove trailing whitespace
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.rb',
  callback = function() vim.cmd [[%s/\s\+$//e]] end,
})
