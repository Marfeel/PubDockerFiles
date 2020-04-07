#!/bin/bash -e

log_location="/var/log/manage-git-users.log"

log () {
  echo "$(date -u): $1" | tee -a "$log_location"
}

usage() {
    echo
    echo "Add or remove a git user, create a git repo or add a user ssh pub key"
    echo
    echo "Usage"
    echo "   $0 ACTION OPTIONS"
    echo "   $0 adduser -u USER -k PUB_KEY_CONTENT "
    echo "   $0 deluser -u USER"
    echo "   $0 create -u USER -r REPOSITORY"
    echo "   $0 addkey -u USER -k PUB_KEY_CONTENT"
    echo
    echo "Actions"
    echo "   adduser adds a new user to the list of git users"
    echo "   deluser removes a user but not its pub keys or repositories"
    echo "   create creates a repository in git for the user"
    echo "   addkey adds an ssh pub key"
    echo
    echo "Options"
    echo "   -u  git user to create or delete. 'git' is already taken"
    echo "   -k  The content of the pub key to add to authorized_keys for that user"
    echo "   -r  The repository to create"
    echo "   -h  This help text"
    echo
}

error()
{
    log "ERROR - $*" >&2
    echo
    usage
    exit 2
}

get_action()
{
    case "$1" in
        adduser|deluser|create|addkey)
          action="$1"
        ;;
        -h)
          usage
          exit 0
        ;;
        *)
          error "Action needs to be one of del or add" 
        ;;
    esac
}

process_opts()
{
    while getopts ":hu:r:k:" opt; do
        case "$opt" in
            h)
                usage
                exit 0
                ;;
            u)
                git_ssh_user="$OPTARG"
                ;;
            k)
                pub_key_content="$OPTARG"
                ;;
            r)
                repository="$OPTARG"
                ;;
            \?)
                error "Invalid option: -$OPTARG"
                ;;
            :)
                error "Option -$OPTARG requires an argument."
                ;;
        esac
    done
}

check_opts()
{
    if [ "z${git_ssh_user}" = "z" ]; then
        error "No user option passed"
    fi

    if [ "${action#add}" != "${action}" ] && [ "z${pub_key_content}" = "z" ]; then
        error "No required pub key contents provided"
    fi

    if [ "${action}" = "create" ] && [ "z${repository}" = "z" ]; then
        error "No required repository name was not provided"
    fi
}

user_doesnt_exists()
{
    if getent passwd "$1" > /dev/null 2>&1; then
        log "user $1 exists"
        return 1
    else
        log "user $1 does not exist"
    fi
}

del_git_user()
{
    if ! user_doesnt_exists "${git_ssh_user}"; then
        deluser "${git_ssh_user}"
        log "Deleted user ${git_ssh_user}"  
    else
        log "WARN: Can't delete git user ${git_ssh_user}"
    fi
}

add_git_user()
{
    if user_doesnt_exists "$git_ssh_user"; then
        adduser -h "${GIT_SERVER_PATH}/data/users/${git_ssh_user}" -g "" -D -s /usr/bin/git-shell "${git_ssh_user}"
        passwd -d "${git_ssh_user}"
        echo "$pub_key_content" >> "${GIT_SERVER_PATH}/data/users/${git_ssh_user}/.ssh/authorized_keys"
        chown -R "${git_ssh_user}":"${git_ssh_user}" "${GIT_SERVER_PATH}/data/users/${git_ssh_user}"
        chmod 700 "${GIT_SERVER_PATH}/data/users/${git_ssh_user}/.ssh"
        chmod -R 600 "${GIT_SERVER_PATH}"/data/users/"${git_ssh_user}"/.ssh/*
        log "Added git user ${git_ssh_user}"
    else
        log "WARN: Can't create git user ${git_ssh_user}"
    fi
}

create_repo() {
    local full_repo_path

    user_doesnt_exists "$git_ssh_user" && \
        error "Cannot create ${repository} for user ${git_ssh_user}: user does not exist"

    full_repo_path="${GIT_SERVER_PATH}/data/users/${git_ssh_user}/${repository}"

    if git -C "$full_repo_path" rev-parse --is-bare-repository 2&> /dev/null; then
        log "WARN: ${repository} repository for user ${git_ssh_user} already exists"
    elif [ -d "${full_repo_path}" ]; then
        error "${full_repo_path} exists and is not a git bare repository"
    else
        git init --bare "${full_repo_path}"
        log "${repository} repository for user ${git_ssh_user} created"
    fi
}

add_user_key() {
    local keys_file key_fingerprint

    user_doesnt_exists "$git_ssh_user" && \
        error "Cannot add user key because user ${git_ssh_user} does not exist"

    keys_file="${GIT_SERVER_PATH}/data/users/${git_ssh_user}/.ssh/authorized_keys"

    if [ ! -f "${keys_file}" ]; then
        error "${keys_file} does not exist!"
    else
        key_fingerprint="$(echo -n "${pub_key_content}" | ssh-keygen -l -E md5 -f -)"
        echo "${pub_key_content}" >> "${keys_file}"
        log "Key ${key_fingerprint} was added to user ${git_ssh_user} authorized_keys"
    fi
}

exec_action()
{
    case "$action" in
        adduser)
            add_git_user
            ;;
        deluser)
            del_git_user
            ;;
        create)
            create_repo
            ;;
        addkey)
            add_user_key
            ;;
    esac
}

main()
{
    get_action "$1"

    # shift the action away
    shift

    process_opts "$@"

    check_opts

    exec_action
}

main "$@"
