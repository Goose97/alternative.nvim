local M = {}

local default_config = {
  rules = {},
  -- The labels to select between multiple rules
  select_labels = "asdfghjkl",
  keymaps = {
    -- Set to false to disable the default keymap for specific actions
    -- alternative_next = false,
    alternative_next = ">",
    alternative_prev = "<",
  },
}

local function setup_keymap(name, rhs, opts)
  local keymaps = M.config.keymaps

  local user_keymap = keymaps[name]

  -- If keymap is disabled by user, skip it
  if not user_keymap then
    return
  end

  local mode = opts.mode
  opts.mode = nil
  vim.keymap.set(mode, user_keymap, rhs, opts)
end

function M.setup(config)
  local user_config = config or {}

  M.config = vim.tbl_deep_extend("force", default_config, user_config)

  setup_keymap("alternative_next", function()
    require("alternative").alternate("forward")
  end, { mode = "n", desc = "Trigger alternative rule in forward direction" })

  setup_keymap("alternative_prev", function()
    require("alternative").alternate("backward")
  end, { mode = "n", desc = "Trigger alternative rule in backward direction" })
end

return M
