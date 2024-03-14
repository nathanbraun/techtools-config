require('zk_bindings').setup()

function UpdateYamlTitle()
  -- Find the proposed title in the buffer
  local proposed_title_pattern = "Proposed Title: (.+)"
  local proposed_title = nil
  for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
    local match = line:match(proposed_title_pattern)
    if match then
      proposed_title = match
      break
    end
  end

  if not proposed_title then
    print("Proposed title not found")
    return
  end

  -- Find and replace the title in the YAML block
  local yaml_start_pattern = "^---$"
  local yaml_end_pattern = "^---$"
  local title_pattern = "title: (.+)"
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local in_yaml_block = false
  for i, line in ipairs(lines) do
    if not in_yaml_block and line:match(yaml_start_pattern) then
      in_yaml_block = true
    elseif in_yaml_block and line:match(yaml_end_pattern) then
      break
    elseif in_yaml_block and line:match(title_pattern) then
      lines[i] = "title: " .. proposed_title
      vim.api.nvim_buf_set_lines(0, i-1, i, false, {lines[i]})
      break
    end
  end
end

vim.api.nvim_set_keymap('n', '<leader>zft', ':lua UpdateYamlTitle()<CR>', { noremap = true, silent = true })
