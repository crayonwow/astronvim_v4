return {
  {
    "rcarriga/nvim-notify",
    opts = function(_, opts)
      opts.render = "wrapped-compact"
      opts.stages = "static"
      opts.max_width = 40
      return opts
    end,
  },
}
