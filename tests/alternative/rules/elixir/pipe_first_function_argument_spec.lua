local alternative = require("alternative")
local helper = require("tests.alternative.helper")

describe("elixir.pipe_first_function_argument", function()
  it("converts single argument function call to pipe", function()
    alternative.setup({
      rules = { "elixir.pipe_first_function_argument" },
    })

    helper.assert_scenario({
      input = [[
        f_oo(bar)
      ]],
      filetype = "elixir",
      input_cursor = "_",
      action = function()
        alternative.alternate("forward")
        helper.wait(10)
      end,
      expected = [[
        bar |> foo()
      ]],
    })
  end)

  it("converts multiple argument function call to pipe", function()
    alternative.setup({
      rules = { "elixir.pipe_first_function_argument" },
    })

    helper.assert_scenario({
      input = [[
        f_oo(bar, fn acc ->
          acc + 1
        end)
      ]],
      filetype = "elixir",
      input_cursor = "_",
      action = function()
        alternative.alternate("forward")
        helper.wait(10)
      end,
      expected = [[
        bar |> foo(fn acc ->
          acc + 1
        end)
      ]],
    })
  end)

  it("converts pipe function call into normal function call", function()
    alternative.setup({
      rules = { "elixir.pipe_first_function_argument" },
    })

    helper.assert_scenario({
      input = [[
        b_ar |> foo(fn acc ->
          acc + 1
        end)
      ]],
      filetype = "elixir",
      input_cursor = "_",
      action = function()
        alternative.alternate("forward")
        helper.wait(10)
      end,
      expected = [[
        foo(bar, fn acc ->
          acc + 1
        end)
      ]],
    })
  end)

  it("ONLY triggers when the cursor is in the function name", function()
    alternative.setup({
      rules = { "elixir.pipe_first_function_argument" },
    })

    helper.assert_scenario({
      input = [[
        foo(ba_r, baz)
      ]],
      filetype = "elixir",
      input_cursor = "_",
      action = function()
        alternative.alternate("forward")
        helper.wait(10)
      end,
      expected = [[
        foo(bar, baz)
      ]],
    })
  end)

  it("ingores control flow functions", function()
    alternative.setup({
      rules = { "elixir.pipe_first_function_argument" },
    })

    helper.assert_scenario({
      input = [[
        if f|oo do
          bar
        end
      ]],
      filetype = "elixir",
      action = function()
        alternative.alternate("forward")
        helper.wait(10)
      end,
      expected = [[
        if foo do
          bar
        end
      ]],
    })

    helper.assert_scenario({
      input = [[
        case f|oo do
          bar -> baz
        end
      ]],
      filetype = "elixir",
      action = function()
        alternative.alternate("forward")
        helper.wait(10)
      end,
      expected = [[
        case foo do
          bar -> baz
        end
      ]],
    })

    helper.assert_scenario({
      input = [[
        co|nd do
          true -> false
        end
      ]],
      filetype = "elixir",
      action = function()
        alternative.alternate("forward")
        helper.wait(10)
      end,
      expected = [[
        cond do
          true -> false
        end
      ]],
    })

    helper.assert_scenario({
      input = [[
        de|f test do
          bar
        end
      ]],
      filetype = "elixir",
      action = function()
        alternative.alternate("forward")
        helper.wait(10)
      end,
      expected = [[
        def test do
          bar
        end
      ]],
    })

    helper.assert_scenario({
      input = [[
        wi|th foo do
          bar
        end
      ]],
      filetype = "elixir",
      action = function()
        alternative.alternate("forward")
        helper.wait(10)
      end,
      expected = [[
        with foo do
          bar
        end
      ]],
    })
  end)
end)
