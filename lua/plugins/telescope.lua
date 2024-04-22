return {
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      opts.defaults.path_display = { "filename_first" }
      opts.defaults.results_title = false
      opts.pickers = {
        ind_files = {
          theme = "dropdown",
        },
        -- current_buffer_fuzzy_find = { sorting_strategy = "descending" },
      }
      return opts
    end,
  },
}
