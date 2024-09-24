local setup = function()
  local maps = { n = {}, i = {}, t = {}, v = {} }

  -- Plugin Manager
  maps.n["<Leader>pi"] = { function() require("lazy").install() end, desc = "Plugins Install" }
  maps.n["<Leader>ps"] = { function() require("lazy").home() end, desc = "Plugins Status" }
  maps.n["<Leader>pS"] = { function() require("lazy").sync() end, desc = "Plugins Sync" }
  maps.n["<Leader>pu"] = { function() require("lazy").check() end, desc = "Plugins Check Updates" }
  maps.n["<Leader>pU"] = { function() require("lazy").update() end, desc = "Plugins Update" }


  -- keymaps from astronvim

  for mode, mode_maps in pairs(maps) do
    for astro_key, map in pairs(mode_maps) do
      local key = string.sub(astro_key, 1, #'<Leader>') == '<Leader>' and '<Leader>' .. astro_key or astro_key
      vim.keymap.set(mode, key, map[1], { desc = map.desc })
    end
  end
end


try(setup, vim.notify);
