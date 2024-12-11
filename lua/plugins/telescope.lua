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
      opts.extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      }
      return opts
    end,
  },
}
