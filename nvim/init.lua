--[[                                         ◢◣
      ◢████◣ ◢██████◤           ◥█████◣      ◥██◤
     ◢██████◣◥█████◤             ◥█████◣ ◣
     ◢███████◣◥██◤🮝◢████████◤◢███◣◥█████◣███ ███◣   ◢███◣████◣████◣
    ◢█◣◥████████◤  ◢███◤    ◢█████◣◥████████ █████ █████◥████◥█████
   ◢███◣◥██████◤ ◢████████◤◢██◤ ◥██◣◥███████ █████ █████ ████ █████
 ◢██████◤◥█████◤ ◢███◤    ◢███◣ ◢███◣◥██████ █████ █████ ████ █████◣
◢██████◤  ◥███◤◢█████████◣◥█████████◤ ◥████◤ █████ █████ ████ ██████◣
🮝🮐🮐🮐🮐🮐🮜    🮝🮐🮜 🮝🮐🮐🮐🮐🮐🮐🮐🮐🮐🮜 🮝🮐🮐🮐🮐🮐🮐🮐🮜   🮝🮐🮐🮜 🮞🮐🮐🮐🮐🮜🮞🮐🮐🮐🮐🮜🮞🮐🮐🮐🮜🮞🮐🮐🮐🮐🮐🮐🮜

 init.lua
]]--

vim.g.mapleader = " "
-- Use OSC52 for clipboard (built-in module requires nvim 0.10+)
if vim.fn.has('nvim-0.10') == 1 then
  vim.g.clipboard = {
    name = "osc52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }
end
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')


---
-- Modified highlight when yanking with different colors for system clipboard
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    local event = vim.v.event
    -- Check if the yank was to the system clipboard (+ register)
    if event.regname == "+" then
      vim.highlight.on_yank({
        higroup = "Search", -- You can change this to any highlight group
        timeout = 250,
        on_macro = false,
      })
      -- Create a custom highlight group for system clipboard yanks
      vim.cmd([[highlight YankToClipboard guibg=#22c55e ctermbg=green]])
      vim.highlight.on_yank({
        higroup = "YankToClipboard",
        timeout = 250,
        on_macro = false,
      })
    else
      -- Normal yank highlighting
      vim.highlight.on_yank()
    end
  end,
})

-- correct type habit of :Wq and :WQ
vim.api.nvim_create_user_command("Wq", "wq", {})
vim.api.nvim_create_user_command("WQ", "wq", {})
vim.api.nvim_create_user_command("Q", "q", {})


vim.keymap.set("v", "<leader>c", function()
  -- yank selection into register "
  vim.cmd('normal! ""y')
  -- get the text from the unnamed register
  local text = vim.fn.getreg('"')
  -- send it to Android clipboard via Termux API
  vim.fn.system("termux-clipboard-set", text)
end, { desc = "Copy to Android clipboard (termux-clipboard-set)" })


