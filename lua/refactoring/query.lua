local parsers = require("nvim-treesitter.parsers")
local ts_utils = require("nvim-treesitter.ts_utils")
local utils = require("refactoring.utils")

--- local myEnum = Enum {
---     'Foo',          -- Takes value 1
---     'Bar',          -- Takes value 2
---     {'Qux', 10},    -- Takes value 10
---     'Baz',          -- Takes value 11
--- }

local Query = {}
Query.__index = Query
Query.query_type = {
    FunctionArgument = "definition.function_argument",
    LocalVar = "definition.local_var",
    Reference = "reference",
}

function Query.get_root(bufnr, lang)
    local parser = parsers.get_parser(bufnr or 0, lang)
    return parser:parse()[1]:root()
end

function Query:new(bufnr, lang, query)
    return setmetatable({
        query = query,
        bufnr = bufnr,
        lang = lang,
        root = Query.get_root(bufnr, lang),
    }, self)
end

function Query:get_scope_over_region(region)
    local start_row, start_col, end_row, end_col = region:to_ts()
    local start_scope = self:get_scope_by_position(
        start_row,
        start_col
    )
    local end_scope = self:get_scope_by_position(
        end_row,
        end_col
    )

    if start_scope ~= end_scope then
        error("Selection spans over two scopes, cannot determine scope")
    end

    return start_scope
end

function Query:get_scope_by_position(line, col)
    local out = nil
    for _, n, _ in self.query:iter_captures(self.root, self.bufnr, 0, -1) do
        if
            ts_utils.is_in_node_range(n, line, col)
            and (out == nil or utils.node_contains(out, n))
        then
            out = n
        end
    end

    return out
end

function Query:pluck_by_capture(scope, capture_name)
    local local_defs = {}
    for id, node, _ in self.query:iter_captures(self.root, self.bufnr, 0, -1) do
        if
            self.query.captures[id] == capture_name
            and utils.node_contains(scope, node)
        then
            table.insert(local_defs, node)
        end
    end

    return local_defs
end

function Query:find_occurances(scope, sexpr)
    -- TODO: Ask tj why my life is terrible
    local sexpr_query = vim.treesitter.parse_query(self.lang, sexpr .. " @tmp_capture")
    for _, n in sexpr_query:iter_captures(scope, self.bufnr, 0, -1) do
        print(vim.inspect(ts_utils.get_node_text(n)))
    end
end

return Query
