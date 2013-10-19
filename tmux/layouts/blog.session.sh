# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "~/jc-public/projects/blog"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "blog"; then

  # Create a new window inline within session layout definition.
  new_window "emacs"
  run_cmd "e site.hs"

  # Load a defined window layout.
  new_window "watch"
  run_cmd "ghc -fforce-recomp --make site.hs"
  run_cmd "./site clean"
  run_cmd "./site watch"

  # Select the default active window on session creation.
  new_window "shell"

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
