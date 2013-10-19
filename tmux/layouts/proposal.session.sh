# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "~/jc-public/projects/proposal"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "proposal"; then

  new_window "emacs"
  run_cmd "e proposal.tex"

  new_window "ipython"
  run_cmd "ipython"

  new_window "shell"
  select_window "shell"

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
