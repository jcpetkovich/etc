# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "~/jc-public/projects/eval-lab/master"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "dm-web"; then

    load_window "emacs-managepy"

    new_window "django-shell"
    run_cmd "./manage.py shell"

    new_window "dbshell"
    run_cmd "./manage.py dbshell"

    new_window "server"
    run_cmd "./manage.py runserver 5000"

    select_window "django-shell"

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
