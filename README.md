# alternative.nvim

Quickly edit code using predefined rules which provide deep support for multiple languages.

https://github.com/user-attachments/assets/cce6c98a-b505-415c-a407-ee2f99da948c

## Table of contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Setup](#setup)
- [Usage](#usage)

## Features

- Edit code using predefined rules
- A set of built-in rules that supports multiple languages
- Support user-defined rules
- Dot repeatable

## Requirements

- [Neovim 0.10+](https://github.com/neovim/neovim/releases)
- [Recommended] [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter): for Treesitter-powered rules, users need to install language parsers. `nvim-treesitter` provides an easy interface to manage them.

## Installation

alternative.nvim supports multiple plugin managers

<details>
<summary><strong>lazy.nvim</strong></summary>

```lua
{
    "Goose97/alternative.nvim",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("alternative").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
}
```
</details>

<details>
<summary><strong>packer.nvim</strong></summary>

```lua
use({
    "Goose97/alternative.nvim",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
        require("alternative").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
})
```
</details>

<details>
<summary><strong>mini.deps</strong></summary>

```lua
local MiniDeps = require("mini.deps");

MiniDeps.add({
    source = "Goose97/alternative.nvim",
})

require("alternative").setup({
    -- Configuration here, or leave empty to use defaults
})
```
</details>

## Setup

You will need to call `require("alternative").setup()` to intialize the plugin. The default configuration contains no rules. Users must manually pick them from a list of [built-in rules](#built-in-rules) or [create custom ones](#custom-rules). Built-in rules can be overriden.

```lua
require("alternative").setup({
    rules = {
        -- Built-in rules
        "general.boolean_flip",
        "general.number_increment_decrement",
        -- Built-in rules and override them
        ["general.compare_operator_flip"] = {
            preview = true
        },
        -- Custom rules
        custom = {

        }
    },
})
```

<details>
<summary><strong>Default configuration</strong></summary>

```lua
{
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
```

</details>

### Keymaps

The default configuration comes with a set of default keymaps:

| Action | Keymap | Description |
| -      | -      | -           |
| alternative_next | > | Trigger alternative rule in forward direction |
| alternative_prev | < | Trigger alternative rule in backward direction |

The direction matters when a rule has multiple outputs. A simple example is the `number_increment_decrement` rule: `forward` will increase and `backword` will decrease the number. Another example is cycling between variants of a word:

```lua
-- Rule definition
button_variants = {
    input = {
        type = "string",
        pattern = "small",
    },
    replacement = { "extra-small", "medium", "large", "extra-large" },
    preview = true
}
```

Users can use `forward` and `backward` to cycle between the possible outputs.

> [!NOTE]
> `preview` must be enabled for the rule for this feature to work.

## Usage

### Built-in rules

- General:
  - [general.boolean_flip](https://github.com/Goose97/alternative.nvim/blob/main/doc/rules/general/boolean_flip.md)
  - [general.compare_operator_flip](https://github.com/Goose97/alternative.nvim/blob/main/doc/rules/general/compare_operator_flip.md)
  - [general.number_increment_decrement](https://github.com/Goose97/alternative.nvim/blob/main/doc/rules/general/number_increment_decrement.md)

- JavaScript:
  - [javascript.if_condition_flip](https://github.com/Goose97/alternative.nvim/blob/main/doc/rules/javascript/if_condition_flip.md)
  - [javascript.ternary_to_if_else](https://github.com/Goose97/alternative.nvim/blob/main/doc/rules/javascript/ternary_to_if_else.md)
  - [javascript.function_definition_variants](https://github.com/Goose97/alternative.nvim/blob/main/doc/rules/javascript/function_definition_variants.md)
  - [javascript.arrow_function_implicit_return](https://github.com/Goose97/alternative.nvim/blob/main/doc/rules/javascript/arrow_function_implicit_return.md)

- TypeScript:
  - [typescript.function_definition_variants](https://github.com/Goose97/alternative.nvim/blob/main/doc/rules/typescript/function_definition_variants.md)

- Lua:
  - [lua.if_condition_flip](https://github.com/Goose97/alternative.nvim/blob/main/doc/rules/lua/if_condition_flip.md)
  - [lua.ternary_to_if_else](https://github.com/Goose97/alternative.nvim/blob/main/doc/rules/lua/ternary_to_if_else.md)
  - [lua.wrap_it_test_in_describe](https://github.com/Goose97/alternative.nvim/blob/main/doc/rules/lua/wrap_it_test_in_describe.md)

- Elixir:
  - [elixir.function_definition_variants](https://github.com/Goose97/alternative.nvim/blob/main/doc/rules/elixir/function_definition_variants.md)
  - [elixir.if_condition_flip](https://github.com/Goose97/alternative.nvim/blob/main/doc/rules/elixir/if_condition_flip.md)
  - [elixir.if_expression_variants](https://github.com/Goose97/alternative.nvim/blob/main/doc/rules/elixir/if_expression_variants.md)
  - [elixir.pipe_first_function_argument](https://github.com/Goose97/alternative.nvim/blob/main/doc/rules/elixir/pipe_first_function_argument.md)

### Custom rules

You can create your own rules. A rule is a table with the following fields:

- `input`: resolved to the input range. It answers "what to replace?".
- `replacement`: resolved to the string to replace. It answers "what to replace the input with?".
- `trigger`: a predicate function to determine whether to trigger the rule.
- `preview`: whether to show a preview of the replacement. Default: false.

<details>
<summary><strong>Type definition</strong></summary>

```lua
---@class Alternative.Rule
---@field input Alternative.Rule.Input How to get the input range
---@field trigger? fun(input: string): boolean Whether to trigger the replacement
---@field replacement string | string[] | fun(ctx: Alternative.Rule.ReplacementContext): string | string[] A string or a callback to resolve the string to replace
---@field preview? boolean Whether to show a preview of the replacement. Default: false
---@field description? string Description of the rule. This is used to generate the documentation.
---@field example? {input: string, output: string} An example input and output. This is used to generate the documentation.
```

</details>

#### input

The input can be one of these types:

1. `string`: simple string pattern lookup

```lua
-- Rule definition
foo = {
    input = {
        type = "string",
        -- If the current word under the cursor matches this, the current word becomes the input
        pattern = "bar",
        -- If true, when the current word doesn't match, look ahead in the same line to find the input
        lookahead = true,
    }
}
```

2. `strings`: similar to the `string` type, but it will match any of the strings

```lua
-- Rule definition
foo = {
    input = {
        type = "strings",
        -- Run the pattern on each string. The first match becomes the input
        pattern = { "bar", "baz" },
        lookahead = true,
    }
}
```

3. `query`: a Treesitter query. There are two requirements for this rule:

- The query must contain a capture named `__input__`. If the query matches, this capture becomes the input.
- The rule must have a `container` field. This field will limit the range when running the query. We first find the closest ancestor of the current node with node type equals `container`. Then we run the query within the container. If no container node is found, the rule is skipped.

```lua
-- Rule definition
foo = {
    input = {
        type = "query",
        -- Run the pattern on each string. The first match becomes the input
        pattern = [[
            (expression_list
                value: (binary_expression
                    left:
                    (binary_expression
                        left: (_) @condition
                        "and"
                        right: (_) @first
                    )
                   "or"
                   right: (_) @second
                )
            ) @__input__
        ]],
        -- This mean the cursor must be inside an `expression_list` node
        -- local foo = a an|d b or c --> This will trigger
        -- local fo|o = a and b or c --> This won't trigger
        container = "expression_list",
    }
}
```

4. `callback`: a function that returns the range of the input text

```lua
-- Rule definition
foo = {
    input = {
        type = "callback",
        pattern = function(),
            local line = vim.fn.line(".")
            -- First 10 characters of the current line
            -- Index is 0-based
            return {line - 1, 0, line - 1, 10}
        end,
    }
}
```

<details>
<summary><strong>Type definition</strong></summary>

```lua
---@class Alternative.Rule.Input
---@field type "string" | "strings" | "callback" | "query"
---@field pattern string | string[] | fun(): integer[]
---@field lookahead? boolean Whether to look ahead from the current cursor position to find the input. Only applied for input with type "string", "strings", or "query". Default: false
---@field container? string A Treesitter node type to limit the input range. Only applies if type is "query". When this is specified, we first traverse up the tree from the current node to find the container, then execute the query within the container. Defaults to use the root as the container.
```

</details>

#### replacement

The `replacement` can be one of these:

1. A string: replace the input with the string

```lua
-- Rule definition
foo = {
    input = {
        type = "string",
        pattern = "bar",
    },
    replacement = "baz",
}
```

2. An array of strings: if `preview` is true, you can cycle through these strings to preview the replacement. If `preview` is false, the first string will be used as the replacement.

```lua
-- Rule definition
foo = {
    input = {
        type = "string",
        pattern = "bar",
    },
    replacement = { "baz", "qux" },
    preview = true,
}
```

3. A function: a function that takes a `Alternative.Rule.ReplacementContext` as the argument and returns a string or an array of strings. The result is used as the replacement.

<details>
<summary><strong>Type definition</strong></summary>

```lua
---@class Alternative.Rule.ReplacementContext
---@field original_text string[]
---@field current_text string[] The current visible text. If a preview is showing, it's the preview text. Otherwise, it's the original_text
---@field direction "forward" | "backward" The cycle direction
---@field query_captures table<string, TSNode>? The Treesitter query captures
```

</details>

In case the input is a `query`, the query captures can be used in the replacement template. This allows you to create some complex rules that are syntax-aware. For example:

```lua
-- Rule definition
foo = {
    input = {
        type = "query",
        -- Run the pattern on each string. The first match becomes the input
        pattern = [[
            (expression_list
                value: (binary_expression
                    left:
                    (binary_expression
                        left: (_) @condition
                        "and"
                        right: (_) @first
                    )
                   "or"
                   right: (_) @second
                )
            ) @__input__
        ]],
        container = "expression_list",
    },
    -- The @capture will be replaced with content of the capture
    -- This rule flips the order of the ternary expression
    -- local foo = a and b or c --> local foo = a and c or b
    replacement = [[
        @condition and @second or @first
    ]]
}
```

See [lua.ternary_to_if_else](https://github.com/Goose97/alternative.nvim/blob/main/doc/rules/lua/ternary_to_if_else.md)
for an example.

### Rule selection

There are cases that trigger multiple rules. In these situations, you can select which rule to apply by pressing corresponding labels.
