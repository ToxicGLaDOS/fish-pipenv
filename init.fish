# set the user installation path

if command -s pipenv > /dev/null
    
    # complete --command pipenv --arguments "(env _PIPENV_COMPLETE=complete-fish COMMANDLINE=(commandline -cp) pipenv)" -f
    
    function __pipenv_shell_activate --on-variable PWD
        if status --is-command-substitution
            return
        end
        # If the PIPENV_MAX_DEPTH variable is defined and the pipenv shell is not active
        if test -n "$PIPENV_MAX_DEPTH" && not test -n "$PIPENV_ACTIVE"
            set -l dir $PWD
            for i in (seq "$PIPENV_MAX_DEPTH")
                echo "Checking $dir/ for Pipfile"
                if test -e "$dir/Pipfile"
                    set -l parent_found 1
                    echo "Pipfile found at $dir"
                    break
                else
                    set dir (dirname "$dir")
                end
            end
        else
            echo 'Else'
        end



        if not test -n "$parent_found"
            if not string match -q "$__pipenv_fish_initial_pwd"/'*' "$PWD/"
                set -U __pipenv_fish_final_pwd "$PWD"
                exit
            end
            return
        end
        
        if not test -n "$PIPENV_ACTIVE"
          echo 'boop'
          if pipenv --venv >/dev/null 2>&1
            echo 'snoop'
            set -x __pipenv_fish_initial_pwd "$PWD"

            if [ "$pipenv_fish_fancy" = 'yes' ]
                set -- __pipenv_fish_arguments $__pipenv_fish_arguments --fancy
            end

            pipenv shell $__pipenv_fish_arguments

            set -e __pipenv_fish_initial_pwd
            if test -n "$__pipenv_fish_final_pwd"
                cd "$__pipenv_fish_final_pwd"
                set -e __pipenv_fish_final_pwd
            end
          end
        end
    end
else
    function pipenv -d "https://pipenv.readthedocs.io/en/latest/"
        echo "Install https://pipenv.readthedocs.io/en/latest/ to use this plugin." > /dev/stderr
        return 1
    end
end
