#!/bin/bash

function venv {
    VENV_DIR=~/.venvs/

    if [[ $1 == "list" ]]; then
        # list all venvs
        ls $VENV_DIR
    elif [[ $1 == "rm" ]]; then
        # remove venv(s)
        for v in ${@:2}; do rm -r "${VENV_DIR}${v}"; done
    elif [[ $1 == "off" ]]; then
        deactivate
    elif [[ $1 == "clear" ]]; then
        # removed all installed packages and activates the environment
        source ${VENV_DIR}/$2/bin/activate
        pip freeze >r.txt
        pip uninstall -r r.txt -y
        rm r.txt
    else
        new_venv_dir="${VENV_DIR}${1}"
        if [ ! -d ${new_venv_dir} ]; then
            # create a new venv
            local py_ver=3.9
            vared -p "Python Version for venv: " py_ver

            # if no pyenv installed, skip this
            # temporarily set the version, so pyenv knows which one to use
            export PYENV_VERSION=${py_ver}
            python${py_ver} -m venv ${new_venv_dir}
            unset PYENV_VERSION
            source ${new_venv_dir}/bin/activate

            # optional: install poetry
            local install_poetry=0
            vared -p "Install poetry? " install_poetry
            if [[ $install_poetry -eq 1 || $install_poetry == "true" ]]
            then
                pip install --upgrade pip poetry -qq
            fi

        else
            # turn off any existing venv. ignore any output
            deactivate &> /dev/null
            # activate existing env
            source ${new_venv_dir}/bin/activate
        fi
    fi
}
