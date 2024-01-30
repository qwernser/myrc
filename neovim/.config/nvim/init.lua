-- vanilla nvim
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

vim.opt.number = true

vim.keymap.set('i', 'jj', '<Esc>')

vim.keymap.set('n', '<C-w><C-w>', '<C-w>c')

vim.keymap.set('n', '<C-t>', function()
    vim.cmd("tab split")
end
)

vim.g.netrw_banner = 0

-- packer.nvim
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    }
    use { "ellisonleao/gruvbox.nvim" }

    use {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end
    }

    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }

    use {
        'nvim-telescope/telescope.nvim',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    use 'neovim/nvim-lspconfig'
    use {
        "williamboman/mason.nvim",
        config = function()
            require('mason').setup()
        end
    }

    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'

    -- use 'saadparwaiz1/cmp_luasnip'
    -- use 'L3MON4D3/LuaSnip'
    -- use "rafamadriz/friendly-snippets"
    use "alvan/vim-closetag"
end)

-- appearance
vim.o.background = "dark"
vim.cmd([[colorscheme gruvbox]])

require('lualine').setup {}

-- lsp, snippets and completion

vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

local telescope = require('telescope')
telescope.setup()

local on_attach = function(_, bufnr)
    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = false, buffer = bufnr }
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gD', function()
        vim.cmd('tab split')
        vim.lsp.buf.declaration()
    end, bufopts)
    vim.keymap.set('n', 'gd', function()
        -- vim.cmd("tab split")
        -- vim.lsp.buf.definition()
        builtin.lsp_definitions()
    end, bufopts)
    vim.keymap.set('n', 'gi', function()
        -- vim.cmd("tab split")
        -- vim.lsp.buf.implementation()
        builtin.lsp_implementations()
    end, bufopts)
    vim.keymap.set('n', 'gr', function()
        -- vim.cmd("tab split")
        -- vim.lsp.buf.references()
        builtin.lsp_references()
    end, bufopts)
    vim.keymap.set({ 'n', 'i' }, '<C-k>', vim.lsp.buf.signature_help, bufopts)
    -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    -- vim.keymap.set('n', '<space>wl', function()
    --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    -- vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting , bufopts)
    vim.keymap.set('n', '<space>f', vim.lsp.buf.format, bufopts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local servers = {
    'pyright', -- pyright
    'gopls', -- gopls
    -- 'sumneko_lua', -- lua-language-server
    -- 'efm'
    'jdtls', -- jdtls
    'tsserver', -- typescript-language-server
    'ccls',
}
local lspconfig = require('lspconfig')
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        capabilities = capabilities,
        on_attach = on_attach,
    }
end
lspconfig.lua_ls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}
local black = {
    formatCommand = "black --fast --line-length 79 -",
    formatStdin = true,
}
local flake8 = {
    lintCommand = "flake8 --extend-ignore=F --ignore=E203,W503 --stdin-display-name ${INPUT} -",
    lintStdin = true,
    lintIgnoreExitCode = true,
    lintFormats = { "%f:%l:%c: %t%n%n %m" },
    lintSource = "flake8",
    lintCategoryMap = {
        E = 'N', -- for the 'H' mark
        W = 'N',
    }
}
lspconfig.efm.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    init_options = { documentFormatting = true },
    root_dir = vim.loop.cwd,
    filetypes = { 'python' },
    settings = {
        rootMarkers = { ".git/" },
        -- logLevel = 5,
        languages = {
            python = {
                black,
                flake8
            },
        },
    },
}

-- local luasnip = require 'luasnip'
-- require("luasnip.loaders.from_vscode").lazy_load()

local cmp = require 'cmp'
if cmp == nil then
    print 'cmp nil'
    return
end
cmp.setup {
    preselect = cmp.PreselectMode.None,
    -- snippet = {
    --     expand = function(args)
    --         luasnip.lsp_expand(args.body)
    --     end,
    -- },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            -- elseif luasnip.expand_or_jumpable() then
            --     luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            -- elseif luasnip.jumpable(-1) then
            --     luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        -- { name = 'luasnip' },
    }, {
        { name = 'buffer' },
    })
}

vim.g.closetag_filetypes = 'html,xhtml,phtml,typescriptreact,javascriptreact'

-- languages
local setShift = function()
    vim.opt.shiftwidth = 2
end
local tsGroup = vim.api.nvim_create_augroup("ts", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "typescriptreact", "typescript", "javascriptreact", "javascript" },
    callback = setShift,
    group = tsGroup,
})
