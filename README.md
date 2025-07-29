# VideRouter

a small thing i made for a failed plugin

you need your own copy of vide, which is NOT provided

## Router.new()
makes a new Router.
```lua
local RouterClass = require(path.to.module)
local Router = RouterClass.new()
```

## Router:init(vide, target, routes)
makes the Router usable. this should be called once! if you want to add more routes, you can insert them into the Router.routes table. you can also edit the length of the tween (which is set to 0 by default) by editing the Router.tweenLength value.

vide is your Vide module.

target is where the router screengui should be made (this is usually the player's playergui, although it can also be placed under another guiobject.)

routes is a table of routes.

```lua
local Vide = path.to.vide
local Player = path.to.player

local Routes = {
    ["/"] = function()
        local Frame = Instance.new("Frame")

        Frame.Size = UDim2.fromScale(1, 1)
        Frame.Parent = Router.ui

        return Frame
    end
}

Router:init(Vide, Player.PlayerGui, Routes)
Router:render()
```

## Router:push(path)
sets the current page.

you must init the Router first!
```lua
local Router = path.to.router
Router:push(Routes["/page"])
```

## Router:back()
goes back a page.

you must init the Router first!
```lua
local Router = path.to.router
Router:back()
```

## Router:getCurrent()
returns the current page.

you must init the Router first!
```lua
local Router = path.to.router
print(Router:getCurrent())
```

## Router:render()
renders the current page.

you must init the Router first!
```lua
local Router = path.to.router
Router:render()
```