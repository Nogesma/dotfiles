function getTwitchUser()
	for w in string.gmatch(mp.get_property("media-title"), "%w+$") do
		return (w);
	end
	
end

function chathandler()
	local user = getTwitchUser()
	os.execute("firefox --new-window https://www.twitch.tv/popout/" .. user .. "/chat?popout")
end

mp.add_key_binding("c", "openchat", chathandler)
