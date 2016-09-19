# config.fish - configure fish

source ~/.config/fish/config/functions

# Load environment only once and when we are a login shell
if begin; status -l; and test $SHLVL -eq 1; end

	# load bash env vars from /etc
	fish_env_update

	# drop duplicates
	varclear fish_user_paths

	# setup PATH
	source ~/.config/fish/config/PATH

	# setup ENV
	source ~/.config/fish/config/ENV

end

# load keybindings
source ~/.config/fish/config/keybinds

# load aliases
source ~/.config/fish/config/alias

# drop greeting
function fish_greeting
end

function fish_mode_prompt
end

# drop cd completions
function __fish_complete_previous_dir
end

# prompt
function fish_prompt
  set last_status $status
  set -l red (set_color red)
  set -l normal (set_color normal)
  set prompt_color $normal
  if [ $last_status != 0 ]
    set prompt_color $red
  end
  echo -n -s $prompt_color '¬ ' $normal
end
