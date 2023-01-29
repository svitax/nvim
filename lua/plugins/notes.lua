return {
  {
    "mickael-menu/zk-nvim",
    name = "zk",
    ft = "markdown",
    opts = {
      picker = "telescope",
    },
    -- config = function(_, opts)
    --   require("zk").setup(opts)
    --   require("telescope").load_extension("zk")
    -- end,
    keys = {
      -- Find notes.
      { "<leader>fn", "<cmd>ZkNotes { sort = {'modified'}}<cr>", desc = "Find notes" },
      { "<leader>nf", "<cmd>ZkNotes { sort = {'modified'}}<cr>", desc = "Find notes" },
      -- Search for the notes matching the current visual selection.
      { "<leader>nF", "<cmd><,'>ZkMatch<cr>", mode = "v", desc = "Find note (selection)" },
      -- "Refresh zk index"
      { "<leader>ni", "<cmd>ZkIndex<cr>", desc = "Refresh index" },
      -- Create a new note after asking for its title.
      { "<leader>nN", "<cmd>ZkNew {title = vim.fn.input('Title: ')}<cr>", desc = "New note" },
      -- Open notes linked by the current buffer.
      { "<leader>nl", "<cmd>ZkLinks<cr>", desc = "Find links" },
      -- Open notes linking to the current buffer.
      { "<leader>nL", "<cmd>ZkBacklinks<cr>", desc = "Find backlinks" },
      -- Open notes associated with the selected tag.
      { "<leader>nt", "<cmd>ZkTags<cr>", desc = "Find tags" },
      -- Create a new note in the same directory as the current buffer, using the current selection for title.
      {
        "<leader>nT",
        ":'<,'>ZkNewFromTitleSelection<CR>",
        mode = "v",
        desc = "New note with selection as title",
      },
      -- Create a new note in the same directory as the current buffer, using the current selection for note content and asking for its title.
      {
        "<leader>nC",
        ":'<,'>ZkNewFromContentSelection { title = vim.fn.input('Title: ') }<CR>",
        mode = "v",
        desc = "New note with selection as content",
      },
    },
  },
}
