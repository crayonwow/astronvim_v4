return {
  "nvim-neotest/neotest",
  opts = {
    adapters = {
      require "neotest-golang" {
        runner = "gotestsum",
        go_test_args = {
          "-v",
          "-race",
          "-count=1",
          "-timeout=90s",
          "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
        },
        testify_enabled = true,
      },
    },
    discovery = {
      enabled = true,
      concurrent = 8,
    },
    running = {
      concurrent = true,
    },
    summary = {
      enabled = true,
      animated = true,
    },
  },
}
