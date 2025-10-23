local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("svelte", {
    s("script", {
        t('<script lang="ts">'),
        t({"", "\t"}),
        i(0),
        t({"", "</script>"})
    }),
})