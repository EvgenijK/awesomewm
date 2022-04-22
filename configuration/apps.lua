return {
	-- The default applications that we will use in keybindings and widgets
	default = {
		-- Default terminal emulator
		terminal = 'x-terminal-emulator',
		-- Default web browser
		web_browser = 'google-chrome',
		-- Default text editor
		text_editor = 'subl',
		-- Default file manager
		--file_manager = 'nautilus',
		-- Default media player
		--multimedia = 'celluloid',
		-- Default game, can be a launcher like steam
		--game = 'env steam',
		-- Default graphics editor
		--graphics = 'gimp',
		-- Default sandbox
		sandbox = 'virt-manager',
		-- Default IDE
		development = 'phpstorm',
		-- Default network manager
		--network_manager = 'nm-connection-editor',
		-- Default bluetooth manager
		--bluetooth_manager = 'blueman-manager',
		-- Default power manager (leaving this here as example)
		--power_manager = 'xfce4-power-manager',
		-- Default GUI package manager
		--package_manager = 'synaptic',
		-- Default locker
		lock = 'slock',

		-- You can add more default applications here
	},

	-- List of apps to start once on start-up
	run_on_start_up = {
		-- IDE
		'google-chrome',
		'phpstorm',
		'x-terminal-emulator',
		'subl',
		'telegram-desktop',
		'discord',
		'virt-manager',

		-- scream audio sink for windows10 VM audio
    	-- 'scream-start',
		
		-- Spawn "dirty" apps that can linger between sessions
		-- It is suggested you copy the contents of awspawn into ~/.config/awesomestart
		-- then remove the "$HOME/.config/awesomestart" line from the APPS array
		-- '~/.config/awesome/configuration/awspawn > /dev/null'

		-- You can add more start-up applications here
	},

	-- List of binaries/shell scripts that will execute for a certain task
	utils = {
	}
}
