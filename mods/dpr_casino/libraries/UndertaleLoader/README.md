# Undertale Loader

An Undertale save loader library for Kristal.
Built off Sylvi's Deltarune save loader library.

## Usage

With the library installed, run `UndertaleLoader.load(filter)` early in your mod:

```lua
function Mod:init()
  -- Loads your Undertale save file
  UndertaleLoader.load()
end
```

After loading, run `UndertaleLoader.getSave()` to get the save data

Here is an example that loads your Undertale save data as soon as you load the game, if you're in a new file.

```lua
function Mod:postInit(new_file)
    if new_file then
        -- Get the Undertale save from the current save slot
        local save = UndertaleLoader.getSave()
        
        -- If save file exists, loads it
        if save then
            save:load()
        end
    end
end
```

This returns a [`UndertaleSave`](scripts/globals/UndertaleSave.lua) instance
