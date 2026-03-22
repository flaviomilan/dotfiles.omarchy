-- AI coding tools
return {
  -- GitHub Copilot (via LazyVim official extra)
  { import = "lazyvim.plugins.extras.coding.copilot" },

  -- CopilotChat: AI chat with explain/review/fix/optimize/docs/tests
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim" },
    },
    opts = {
      model = "claude-sonnet-4-5",
      window = { width = 0.4 },
    },
    keys = {
      { "<leader>aa", "<cmd>CopilotChatToggle<cr>", desc = "Toggle Copilot Chat" },
      {
        "<leader>ae",
        function()
          local input = vim.fn.input("Explain: ")
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").visual })
          end
        end,
        mode = "v",
        desc = "Explain selection",
      },
      {
        "<leader>ae",
        function()
          require("CopilotChat").ask("Explain this code", { selection = require("CopilotChat.select").buffer })
        end,
        desc = "Explain buffer",
      },
      { "<leader>ar", "<cmd>CopilotChatReview<cr>", desc = "Review code" },
      { "<leader>af", "<cmd>CopilotChatFix<cr>", desc = "Fix code" },
      { "<leader>ao", "<cmd>CopilotChatOptimize<cr>", desc = "Optimize code" },
      { "<leader>ad", "<cmd>CopilotChatDocs<cr>", desc = "Generate docs" },
      { "<leader>at", "<cmd>CopilotChatTests<cr>", desc = "Generate tests" },
      {
        "<leader>am",
        "<cmd>CopilotChatCommitStaged<cr>",
        desc = "Generate commit message",
      },
    },
  },
}
