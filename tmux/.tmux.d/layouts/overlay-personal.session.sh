# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "~/jc-public/projects/overlay-eyolfson"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "overlay"; then

  new_window "emacs"
  run_cmd "new-ebuild.sh"

  new_window "ebuild"
  select_window "emacs"

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
