# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "~/jc-public/projects/eval-lab/worker"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "dm-wrkr"; then

    load_window "emacs-managepy"

    new_window "worker-shell"
    run_cmd "./manage.py test && sleep 10 && exit"
    split_v 50
    run_cmd "./manage.py shell"

    new_window "shell"
    
    select_window "worker-shell"

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
