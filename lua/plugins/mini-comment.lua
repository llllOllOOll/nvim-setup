return {
    {
        "echasnovski/mini.comment",
        version = false, -- Use the latest stable version
        event = "VeryLazy",
        config = function()
            require("mini.comment").setup({
                -- Module mappings. Use `''` (empty string) to disable one.
                mappings = {
                    -- Toggle comment (like `gcip`)
                    comment = 'gc',
                    -- Toggle comment with pre/postfix (like `gcsip`)
                    comment_line = 'gcc',
                    -- Define 'comment' textobject (like `dgc`)
                    textobject = 'gc',
                },
                
                -- Options which control module behavior
                options = {
                    -- Function to compute comment string
                    comment_string = nil,
                    -- Whether to ignore blank lines
                    ignore_blank_line = false,
                    -- Whether to recognize as comment only lines without indent
                    start_of_line = false,
                    -- Whether to force single space inner padding for comment parts
                    pad_comment_parts = true,
                },
                
                -- Hook functions to be executed at certain stage of commenting
                hooks = {
                    -- Before successful commenting. Receives `ctx` argument.
                    pre = nil,
                    -- After successful commenting. Receives `ctx` argument.
                    post = nil,
                },
            })
        end,
    },
}