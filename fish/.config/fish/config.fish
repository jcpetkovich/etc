# config.fish - configure fish

source ~/.config/fish/configs/functions

# Load environment only once and when we are a login shell
if begin; status -l; and test $SHLVL -eq 1; end

	# load bash env vars from /etc
	fish_env_update

	# drop duplicates
	varclear fish_user_paths

	# setup PATH
	source ~/.config/fish/configs/PATH

	# setup ENV
	source ~/.config/fish/configs/ENV

end

# load keybindings
source ~/.config/fish/configs/keybinds

# load aliases
source ~/.config/fish/configs/alias

# drop greeting
function fish_greeting
end

function fish_mode_prompt
end

# prompt
powerline-setup
if not pgrep -f powerline-daemon > /dev/null
				powerline-daemon
end
