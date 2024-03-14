local M = {}
function M.setup()

  local opts = { noremap = true, silent = true}
  local keymap = vim.api.nvim_buf_set_keymap
  local helpers = require('zk_helpers')

  vim.keymap.set('n', '<leader>zbl', '<Cmd>ZkBacklinks { sort = {"modified"} }<CR>', opts)
  vim.keymap.set('n', '<leader>zfl', '<Cmd>ZkLinks { sort = {"modified"} }<CR>', opts)
  vim.keymap.set('n', '<leader>zt', '<Cmd>ZkTags<CR>', opts)
  vim.keymap.set('n', '<leader>zx', '<Cmd>ZkIndex<CR>', opts)


  vim.keymap.set('n', '<leader>dj', function() helpers.zkDayNoteOffset(1) end, opts)
  vim.keymap.set('n', '<leader>dk', function() helpers.zkDayNoteOffset(-1) end, opts)

  vim.keymap.set('v', '<leader>zx', ":'<,'>ZkNewFromContentSelection<CR>", opts)

  vim.keymap.set('n', '<leader>zon', '<Cmd>ZkNotes { sort = {"modified"} }<CR>', opts)
  vim.keymap.set('n', '<leader>zj', '<Cmd>ZkNotes { sort = {"modified"} }<CR>', opts)
  vim.keymap.set('n', '<leader>zs', helpers.zkNotesWithOpenPaths, opts)

  local zk = require("zk")
  local commands = require("zk.commands")

  -- new notes
  vim.keymap.set('v', '<leader>znn', ":'<,'>ZkNewFromTitleSelection<CR>", opts)

  vim.keymap.set('n', '<leader>znn', '<Cmd>ZkNew<CR>', opts)
  vim.keymap.set("n", "<leader>znc", '<Cmd>ZkNew { template = "concept.md"}<CR>', opts)
  vim.keymap.set("n", "<leader>zns", '<Cmd>ZkNew { template = "source.md"}<CR>', opts)
  vim.keymap.set("n", "<leader>znpe", '<Cmd>ZkNew { template = "person.md"}<CR>', opts)
  vim.keymap.set("n", "<leader>znpr", '<Cmd>ZkNew { template = "project.md"}<CR>', opts)
  vim.keymap.set("n", "<leader>zna", ":AINewPersistentChat<CR>", { silent = true })
  vim.keymap.set("n", "<leader>znm", '<Cmd>ZkNew { template = "meeting.md"}<CR>', opts)
  vim.keymap.set("n", "<leader>znt", '<Cmd>ZkNew { template = "topic.md"}<CR>', opts)
  vim.keymap.set("n", "<leader>znh", '<Cmd>ZkNew { template = "howto.md"}<CR>', opts)
  vim.keymap.set("n", "<leader>znl", '<Cmd>ZkNew { template = "location.md"}<CR>', opts)
  vim.keymap.set("n", "<leader>znr", '<Cmd>ZkNew { template = "reference.md"}<CR>', opts)
  vim.keymap.set("n", "<leader>znq", '<Cmd>ZkNew { template = "quote.md"}<CR>', opts)
  vim.keymap.set("n", "<leader>znb", '<Cmd>ZkNew { template = "book.md"}<CR>', opts)

  commands.add("ZkYankName", function(options) helpers.yankName(options, { title = "Zk Yank" }) end)

  vim.keymap.set('n', '<leader>lwe', helpers.zkWeekNote, opts)
  vim.keymap.set('n', '<leader>wj', function() helpers.zkWeekNoteOffset(1) end, opts)
  vim.keymap.set('n', '<leader>wk', function() helpers.zkWeekNoteOffset(-1) end, opts)

  -- insert link by type in visual mode
  vim.keymap.set("v", "[[n", ":'<,'>ZkInsertLinkAtSelection<CR>", opts)
  vim.keymap.set("v", "[[c", ":'<,'>ZkInsertLinkAtSelection { tags = {'concept'}, sort = {'modified'}}<CR>", opts)
  vim.keymap.set("v", "[[s", ":'<,'>ZkInsertLinkAtSelection { tags = {'source'}, sort = {'modified'}}<CR>", opts)
  vim.keymap.set("v", "[[pe", ":'<,'>ZkInsertLinkAtSelection { tags = {'person'}, sort = {'title'}}<CR>", opts)
  vim.keymap.set("v", "[[pr", ":'<,'>ZkInsertLinkAtSelection { tags = {'project'}, sort = {'modified'}}<CR>", opts)
  vim.keymap.set("v", "[[a", ":'<,'>ZkInsertLinkAtSelection { tags = {'aichat'}, sort = {'modified'}}<CR>", opts)
  vim.keymap.set("v", "[[m", ":'<,'>ZkInsertLinkAtSelection { tags = {'meeting'}, sort = {'modified'}}<CR>", opts)
  vim.keymap.set("v", "[[t", ":'<,'>ZkInsertLinkAtSelection { tags = {'topic'}}<CR>", opts)
  vim.keymap.set("v", "[[h", ":'<,'>ZkInsertLinkAtSelection { tags = {'howto'}, sort = {'modified'}}<CR>", opts)
  vim.keymap.set("v", "[[l", ":'<,'>ZkInsertLinkAtSelection { tags = {'location'}, sort = {'modified'}}<CR>", opts)
  vim.keymap.set("v", "[[r", ":'<,'>ZkInsertLinkAtSelection { tags = {'reference'}, sort = {'modified'}}<CR>", opts)
  vim.keymap.set("v", "[[q", ":'<,'>ZkInsertLinkAtSelection { tags = {'quote'}}<CR>", opts)
  vim.keymap.set("v", "[[b", ":'<,'>ZkInsertLinkAtSelection { tags = {'book'}}<CR>", opts)
  vim.keymap.set("v", "[[d", ":'<,'>ZkInsertLinkAtSelection { tags = {'day'}, sort = {'modified'}}<CR>", opts)
  vim.keymap.set("v", "[[w", ":'<,'>ZkInsertLinkAtSelection { tags = {'week'}, sort = {'modified'}}<CR>", opts)

  -- insert link by type in insert mode
  vim.keymap.set("i", "[[n", "<Cmd>ZkYankName<CR>", opts)
  vim.keymap.set("i", "[[c", '<Cmd>ZkYankName { tags = {"concept"}, sort = {"modified"}}<CR>', opts)
  vim.keymap.set("i", "[[s", '<Cmd>ZkYankName { tags = {"source"}, sort = {"modified"}}<CR>', opts)
  vim.keymap.set("i", "[[pe", '<Cmd>ZkYankName { tags = {"person"}, sort = {"title"}}<CR>', opts)
  vim.keymap.set("i", "[[pr", '<Cmd>ZkYankName { tags = {"project"}, sort = {"modified"}}<CR>', opts)
  vim.keymap.set("i", "[[a", '<Cmd>ZkYankName { tags = {"aichat"}, sort={"modified"}}<CR>', opts)
  vim.keymap.set("i", "[[m", '<Cmd>ZkYankName { tags = {"meeting"}, sort = {"modified"}}<CR>', opts)
  vim.keymap.set("i", "[[t", '<Cmd>ZkYankName { tags = {"topic"}}<CR>', opts)
  vim.keymap.set("i", "[[h", '<Cmd>ZkYankName { tags = {"howto"}, sort = {"modified"}}<CR>', opts)
  vim.keymap.set("i", "[[l", '<Cmd>ZkYankName { tags = {"location"}, sort = {"modified"}}<CR>', opts)
  vim.keymap.set("i", "[[r", '<Cmd>ZkYankName { tags = {"reference"}, sort = {"modified"}}<CR>', opts)
  vim.keymap.set("i", "[[q", '<Cmd>ZkYankName { tags = {"quote"}}<CR>', opts)
  vim.keymap.set("i", "[[b", '<Cmd>ZkYankName { tags = {"book"}}<CR>', opts)
  vim.keymap.set("i", "[[d", '<Cmd>ZkYankName { tags = {"day"}, sort = {"modified"}}<CR>', opts)
  vim.keymap.set("i", "[[w", '<Cmd>ZkYankName { tags = {"week"}, sort = {"modified"}}<CR>', opts)

  -- open note by type 
  vim.keymap.set("n", "<leader>zoc", '<Cmd>ZkNotes { tags = {"concept"}, sort = {"modified"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zos", '<Cmd>ZkNotes { tags = {"source"}, sort = {"modified"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zope", '<Cmd>ZkNotes { tags = {"person"}, sort = {"modified"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zopr", '<Cmd>ZkNotes { tags = {"project"}, sort = {"modified"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zoa", '<Cmd>ZkNotes { tags = {"aichat"}, sort = {"modified"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zom", '<Cmd>ZkNotes { tags = {"meeting"}, sort = {"modified"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zot", '<Cmd>ZkNotes { tags = {"topic"}, sort = {"modified"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zoh", '<Cmd>ZkNotes { tags = {"howto"}, sort = {"modified"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zol", '<Cmd>ZkNotes { tags = {"location"}, sort = {"modified"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zor", '<Cmd>ZkNotes { tags = {"reference"}, sort = {"modified"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zoq", '<Cmd>ZkNotes { tags = {"quote"}, sort = {"modified"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zob", '<Cmd>ZkNotes { tags = {"book"}, sort = {"modified"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zod", '<Cmd>ZkNotes { tags = {"day"}, sort = {"modified"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zow", '<Cmd>ZkNotes { tags = {"week"}, sort = {"modified"} }<CR>', opts)

  -- open backlinks by type 
  vim.keymap.set("n", "<leader>zbn", '<Cmd>ZkBacklinks { sort = {"modified"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zbc", '<Cmd>ZkBacklinks { tags = {"concept"}, sort = {"title"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zbs", '<Cmd>ZkBacklinks { tags = {"source"}, sort = {"title"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zbpe", '<Cmd>ZkBacklinks { tags = {"person"}, sort = {"title"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zbpr", '<Cmd>ZkBacklinks { tags = {"project"}, sort = {"title"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zba", '<Cmd>ZkBacklinks { tags = {"aichat"}, sort = {"title"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zbm", '<Cmd>ZkBacklinks { tags = {"meeting"}, sort = {"title"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zbt", '<Cmd>ZkBacklinks { tags = {"topic"}, sort = {"title"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zbh", '<Cmd>ZkBacklinks { tags = {"howto"}, sort = {"title"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zbl", '<Cmd>ZkBacklinks { tags = {"location"}, sort = {"title"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zbr", '<Cmd>ZkBacklinks { tags = {"reference"}, sort = {"title"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zbq", '<Cmd>ZkBacklinks { tags = {"quote"}, sort = {"title"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zbb", '<Cmd>ZkBacklinks { tags = {"book"}, sort = {"title"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zbd", '<Cmd>ZkBacklinks { tags = {"day"}, sort = {"title"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zbw", '<Cmd>ZkBacklinks { tags = {"week"}, sort = {"title"} }<CR>', opts)

  -- open links by type 
  vim.keymap.set("n", "<leader>zln", '<Cmd>ZkLinks { sort = {"title"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zlc", '<Cmd>ZkLinks { tags = {"concept"}, sort = {"title"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zls", '<Cmd>ZkLinks { tags = {"source"}, sort = {"title"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zlpe", '<Cmd>ZkLinks { tags = {"person"}, sort = {"title"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zlpr", '<Cmd>ZkLinks { tags = {"project"}, sort = {"title"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zla", '<Cmd>ZkLinks { tags = {"aichat"}, sort = {"title"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zlm", '<Cmd>ZkLinks { tags = {"meeting"}, sort = {"title"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zlt", '<Cmd>ZkLinks { tags = {"topic"}, sort = {"title"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zlh", '<Cmd>ZkLinks { tags = {"howto"}, sort = {"title"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zll", '<Cmd>ZkLinks { tags = {"location"}, sort = {"title"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zlr", '<Cmd>ZkLinks { tags = {"reference"}, sort = {"title"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zlq", '<Cmd>ZkLinks { tags = {"quote"}, sort = {"title"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zlb", '<Cmd>ZkLinks { tags = {"book"}, sort = {"title"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zld", '<Cmd>ZkLinks { tags = {"day"}, sort = {"title"} }<CR>', opts)
  vim.keymap.set("n", "<leader>zlw", '<Cmd>ZkLinks { tags = {"week"}, sort = {"title"} }<CR>', opts)

  vim.api.nvim_create_user_command('CreateLink', helpers.CreateMarkdownLinkFromWiki, {})

  vim.keymap.set('n', '<leader>zyt', '<Cmd>CreateLink<CR>', opts)
  vim.keymap.set('n', 'zT', '<Cmd>CreateLink<CR>', opts)

  vim.api.nvim_create_user_command('CopyFilePath', helpers.CopyFilePathToRegister, {})
  vim.keymap.set('n', '<leader>zyf', '<Cmd>CopyFilePath<CR>', opts)

end

return M
