local TweenService = game:GetService("TweenService")

local Router = {}
Router.__index = Router

function Tween(Object, Time, Goal)
	assert(Object, "Invalid object to tween")
	assert(Goal, "Invalid goals for object")

	if Time > 0 then
		TweenService:Create(
			Object,
			TweenInfo.new(Time, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
			Goals
		):Play()
	else
		for Property, Value in Goals do
			assert(Object[Property], string.format("Object has no property of name %s", Property))
			assert(typeof(Object[Property]) == typeof(Value), string.format("Type of property %s is %s, given %s", Property, typeof(Object[Property]), typeof(Value))
			
			Object[Property] = Value
		end
	end
end

function Router.new()
	local self = setmetatable({}, Router)

	self.routes = {}
	self.path = "/"
	self.history = {}

	self._vide = nil
	self._destroyer = nil
	
	self.tweenLength = 0

	return self
end

function Router:init(vide, target, routes)
	if self._vide ~= nil then
		warn("[Router] Router has already been initiated")
	end

	self.routes = routes or {}
	self.path = "/"

	self._target = target
	self._vide = vide

	table.insert(self.history, self.path)
end

function Router:push(path)
	if self._vide == nil then
		warn("[Router] Router has not been initiated")
	end

	if self.routes[path] then
		self.path = path
		self:render()

		table.insert(self.history, path)
	else
		warn(`[Router] No route defined for path '{path}'`)
	end
end

function Router:back()
	if self._vide == nil then
		warn("[Router] Router has not been initiated")
	end

	if #self.history > 1 then
		table.remove(self.history)

		self.path = self.history[#self.history]
		self:render()
	end
end

function Router:getCurrent()
	if self._vide == nil then
		warn("[Router] Router has not been initiated")
		return nil
	end

	return self.routes[self.path]
end

function Router:render()
	if self._vide == nil then
		warn("[Router] Router has not been initiated")
	end

	local current = self:getCurrent()

	if current then
		if self._destroyer then
			self._destroyer()
		end

		task.wait(tweenLength)

		self._destroyer = self._vide.root(function()
			local canvas = self._vide.create("CanvasGroup")({
				Parent = self._target,

				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,

				GroupTransparency = 1,
			})

			local frame = current(self)
			frame.Parent = canvas

			TweenService:Create(
				canvas,
				TweenInfo.new(tweenLength, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
				{ GroupTransparency = 0 }
			):Play()

			self._vide.cleanup(function()
				TweenService:Create(
					canvas,
					TweenInfo.new(tweenLength, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
					{ GroupTransparency = 1 }
				):Play()

				task.delay(tweenLength, function()
					frame:Destroy()
					canvas:Destroy()
				end)
			end)
		end)
	else
		warn(`[Router] {self.path} not found`)
	end
end

return Router
