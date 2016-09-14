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
  run_cmd "cabal build"
  run_cmd "cabal run clean"
  run_cmd "cabal run watch"

  # Select the default active window on session creation.
  new_window "shell"
  run_cmd "firefox localhost:8000"

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
