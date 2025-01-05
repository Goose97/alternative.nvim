# lua.if_condition_flip

## Source Code

<details>
<summary><strong>Show</strong></summary>

```lua
local function if_statement_query()
  local clause = function(operator)
    return string.format(
      [[
        (if_statement
          condition:
            (binary_expression
              left: (_)
              "%s" @__input__
              right: (_)
            )
        )
      ]],
      operator
    )
  end

  local operators = { "==", "~=", ">", "<", ">=", "<=" }
  local clauses = vim.iter(operators):map(clause):totable()
  return table.concat(clauses, "\n")
end

return {
  {
    input = {
      type = "query",
      pattern = if_statement_query(),
      container = "if_statement",
      lookahead = true,
    },
    replacement = function(ctx)
      local mapping = {
        ["~="] = "==",
        ["=="] = "~=",
        [">"] = "<",
        ["<"] = ">",
        [">="] = "<=",
        ["<="] = ">=",
      }

      return mapping[ctx.original_text[1]]
    end,
    filetype = "lua",
    description = "Flip the compare operator",
    example = {
      input = "if a| == b then return true end",
      output = "if a ~= b then return true end",
    },
  },
  {
    input = {
      type = "query",
      pattern = [[
        (if_statement
          condition: (_) @__input__
          (#not-type? @__input__ "binary_expression")
        )
      ]],
      container = "if_statement",
      lookahead = true,
    },
    replacement = { "not (@__input__)" },
    preview = true,
    filetype = "lua",
    description = "Append not",
    example = {
      input = "i|f foo(bar, baz) then return true end",
      output = "if not (foo(bar, baz)) then return true end",
    },
  },
}
```

</details>

## Examples

> [!NOTE]
> `|` denotes the cursor position.

### Flip the compare operator

- Input:

```lua
if a| == b then return true end
```

- Output:

```lua
if a ~= b then return true end
```

### Append not

- Input:

```lua
i|f foo(bar, baz) then return true end
```

- Output:

```lua
if not (foo(bar, baz)) then return true end
```