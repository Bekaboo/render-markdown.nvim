---@class render.md.Util
local M = {}

M.has_10 = vim.fn.has('nvim-0.10') == 1

---@param name string
---@return string[]
function M.lazy_file_types(name)
    -- https://github.com/folke/lazydev.nvim/blob/main/lua/lazydev/pkg.lua -> get_plugin_path
    if type(package.loaded.lazy) ~= 'table' then
        return {}
    end
    local ok, lazy_config = pcall(require, 'lazy.core.config')
    if not ok then
        return {}
    end
    local plugin = lazy_config.spec.plugins[name]
    if plugin == nil then
        return {}
    end
    local file_types = plugin.ft
    if type(file_types) == 'table' then
        return file_types
    elseif type(file_types) == 'string' then
        return { file_types }
    else
        return {}
    end
end

---@param buf integer
---@param win integer
---@return boolean
function M.valid(buf, win)
    return vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_win_is_valid(win)
end

---@return string
function M.mode()
    return vim.fn.mode(true)
end

---@param buf integer
---@param win integer
---@return integer?
function M.row(buf, win)
    if vim.api.nvim_get_current_buf() ~= buf then
        return nil
    end
    return vim.api.nvim_win_get_cursor(win)[1] - 1
end

---@param win integer
---@param name string
---@return number|string|boolean
function M.get_win(win, name)
    return vim.api.nvim_get_option_value(name, { scope = 'local', win = win })
end

---@param win integer
---@param name string
---@param value number|string|boolean
function M.set_win(win, name, value)
    vim.api.nvim_set_option_value(name, value, { scope = 'local', win = win })
end

---@param buf integer
---@param name string
---@return number|string|boolean
function M.get_buf(buf, name)
    return vim.api.nvim_get_option_value(name, { buf = buf })
end

---@param win integer
---@return vim.fn.winsaveview.ret
function M.view(win)
    return vim.api.nvim_win_call(win, vim.fn.winsaveview)
end

---@param win integer
---@param row integer
---@return boolean
function M.visible(win, row)
    return vim.api.nvim_win_call(win, function()
        return vim.fn.foldclosed(row) == -1
    end)
end

---@param file string
---@return number
function M.file_size_mb(file)
    local ok, stats = pcall(function()
        return vim.uv.fs_stat(file)
    end)
    if not (ok and stats) then
        return 0
    end
    return stats.size / (1024 * 1024)
end

return M
