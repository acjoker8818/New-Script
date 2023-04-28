--[[Highly recommend starting here https://github.com/Keramis/Lua_STANDAPI this will get you started.]]

--[[
Basically have at least these two websites open at all times and read them both when using 
nativeDB = https://nativedb.dotindustries.dev/natives  
Stand API = https://stand.gg/help/lua-api-documentation 

Make sure you are using a code editor to do this it makes life much easier. I suggest Sublime Text but at least Visual
Studio Code]]

--[[Feel free to delete this and make it your own]]

--[[This is for beginners to get started with lua/pluto and be able write a basic scipt
for every script you will need util.keep_running() so the script doesnt stop instantly it can be at the beginning or end]]
util.keep_running()

--[[If you want to do anything with the game pretty much you will need to require game natives with util.require_natives()
check the latest version before starting]]
util.require_natives(1676318796)

--[[First you will want to start with something easy to put something in the main part of your script you need
menu.my_root() to shorten it you could go with local my_root = menu.my_root(). menu.my_root() is known as the command
reference here]]
local my_root = menu.my_root()

--[[menu.action(my_root, 'Name', {'command_name'}, 'Description', function ()
end)
 This is a basic action that does nothing but says Hello shows you and how one is setup the first part my_root is the location
  of the command if you want to do it short hand you can do my_root:action('Name', {'command_name'}, 'Description', function ()
end) which would be the same thing just the location is before the action not in the brackets]]

menu.action(my_root, 'Test Button', {''}, 'Button that toast Hello', function ()
	util.toast('Hello')
end)

my_root:action('Test Button 2', {''}, 'Button that toast Goodbye', function ()--using the shorthand version
    util.toast('Goodbye')
end)

--toggles can turn something on and off as shown but is only done once
menu.toggle(my_root, 'Test Toggle', {''}, 'Toggle that toast on or off', function (on)
	if on then
		util.toast('On')
	else
		util.toast('Off')
	end
end)

--[[Toggle_loops will continue to do stuff over and over until it is turned off.
 You can also have toggle_loops do stuff when they are turned off like the function below]]

menu.toggle_loop(my_root, 'Test Toggle Loop', {''}, 'Toggle that toast on in a loop and off when turned off', function ()
	util.toast('On')
end, function ()
	util.toast('Off')
end)

--[[If you want to Spawn or something else you will need to request that model and wait until that model has finished loading. 
If you put the hash into this function it will load the model if it does not load it will tell you the hash is invalid.
 For msecs you put the amount of time you want to wait before it timesout]]

function Streammodel(hash, msecs) 
    util.request_model(hash, msecs)
end

--[[If you want to spawn a ped(pedestrian) at your coordinates you can use this. You can use hash (numbers) or a
string like I did here if you use a string like I did you have to use util.joaat. To Spawn a ped You need a postion
which has 3 numbers connect to it x, y, and z. Using entities.create_ped(1, hash, pos, 0) makes it easier to spawn them 
because you down have to right down the x, y, and z. The 1 is the model type I always seem to use 1. The Hash  is the 
hash of the ped you want. The pos is the position you want to spawn the ped. And the 0 is the heading you want to set.
The other way is commented out in the code. For how to set those look at the nativeDB]]

menu.action(my_root, 'Test Ped Spawn', {''}, 'Button that spawns a Ped', function ()
    local hash = util.joaat('a_f_y_rurmeth_01')
    Streammodel(hash, 2000)
    local pos = ENTITY.GET_ENTITY_COORDS(players.user_ped())
    entities.create_ped(1, hash, pos, 0)
    --PED.CREATE_PED(1, hash, pos.x, pos.y, pos.z, 0, true, true)
end)

--[[You need to do similar for vehicles and get the information you need to spawn it and also request the model.
Everything is the same as above just for a vehicle but with a offset to the players coords so it isnt right on top
of you. Look at the nativeDB for proper way to set the natives if you use those instead]]

menu.action(my_root, 'Test Vehicle Spawn', {''}, 'Button that spawns a Vehicle', function ()
    local hash = util.joaat('baller7')
    Streammodel(hash, 2000)
    local pos = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, 3, 0)
    --x = left/right, y = forward/backward, z = up/down
    entities.create_vehicle(hash, pos, 0)
    --VEHICLE.CREATE_VEHICLE(hash, pos.x, pos.y, pos.z, 0, true, true, false)
end)

--[[This would be how you add stuff to the menu under player options in this part I will be using the 
 menu.player_root(pid): symbol for the location in the menu intead of having it like menu.action(menu.player_root(pid))
easier to start off like that. ]]

players.add_command_hook(function(pid) -- you will need the pid for most things
    --divider for the name of your script in the player menu
    menu.player_root(pid):divider("My Script")

    --[[Adding COMMANDPERM_FRIENDLY to the end like it was done here makes it to where if friendly options are set for
    chat commands. ]]

    menu.player_root(pid):action("Teleport to them", {"tptoplayer"}, "Teleport yourself to them", function()
        local target = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid) --first you will want to get their Player Ped
        local tar_coords = ENTITY.GET_ENTITY_COORDS(target, true) --next get their coordinates
        ENTITY.SET_ENTITY_COORDS(players.user_ped(), tar_coords.x, tar_coords.y, tar_coords.z, false, false, false, false)
        --finally teleport to them, you can use players.user_ped() to get your player ped
    end, nil, nil, COMMANDPERM_FRIENDLY)

    --to make a list in the players menu
    local list_examp =  menu.player_root(pid):list('List', {'list'}, 'List of stuff')

    --[[Now to put stuff in that list now just use list_examp as your command reference and put list_examp:action(etc)
    instead of menu.action(list_examp..etc)]] 
    list_examp:action('Action', {'action'}, 'Test action button that shows you player name', function ()
    	local pname = PLAYER.GET_PLAYER_NAME(pid)
        util.toast('Players name is '..pname)
    end)

    list_examp:toggle_loop('Toggle Loop', {'PLTL'}, 'Toggle that toast player name in a loop and off when turned off', function ()
        local pname = PLAYER.GET_PLAYER_NAME(pid)
        util.toast('Players name is '..pname)
    end, function ()
        util.toast('Off')
    end)

    --more stuff you want to add to players options here







    ---end of player options
end)