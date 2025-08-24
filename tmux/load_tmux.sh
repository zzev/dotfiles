#!/bin/bash

set -e

# Configuration
DEFAULT_SESSION_NAME="main"
SCRIPT_NAME=$(basename "$0")

# Find tmux binary dynamically
if ! TMUX_BIN=$(command -v tmux 2>/dev/null); then
    echo "Error: tmux is not installed or not in PATH" >&2
    exit 1
fi

# Function to show usage
show_usage() {
    cat << EOF
Usage: $SCRIPT_NAME [SESSION_NAME] [OPTIONS]

Attach to an existing tmux session or create a new one.

Arguments:
    SESSION_NAME    Name of the tmux session (default: $DEFAULT_SESSION_NAME)

Options:
    -l, --list      List all available sessions and exit
    -h, --help      Show this help message

Examples:
    $SCRIPT_NAME              # Attach to '$DEFAULT_SESSION_NAME' or first available session
    $SCRIPT_NAME work         # Attach to or create 'work' session
    $SCRIPT_NAME --list       # List all sessions
EOF
}

# Function to list sessions
list_sessions() {
    if "$TMUX_BIN" has-session 2>/dev/null; then
        echo "Available tmux sessions:"
        "$TMUX_BIN" list-sessions -F '#{session_name}: #{session_windows} windows (created #{t:session_created})'
    else
        echo "No tmux sessions found."
    fi
}

# Function to check if session exists
session_exists() {
    local session_name="$1"
    "$TMUX_BIN" has-session -t "$session_name" 2>/dev/null
}

# Function to get first available session
get_first_session() {
    "$TMUX_BIN" list-sessions -F '#{session_name}' 2>/dev/null | head -n 1
}

# Function to attach or create session
attach_or_create() {
    local target_session="$1"
    
    if session_exists "$target_session"; then
        echo "Attaching to existing session: $target_session"
        exec "$TMUX_BIN" attach-session -t "$target_session"
    else
        echo "Creating new session: $target_session"
        exec "$TMUX_BIN" new-session -s "$target_session"
    fi
}

# Main logic
main() {
    # Already in a tmux session?
    if [[ -n "$TMUX" ]]; then
        echo "Already inside a tmux session" >&2
        exit 0
    fi

    # Parse arguments
    case "${1:-}" in
        -h|--help)
            show_usage
            exit 0
            ;;
        -l|--list)
            list_sessions
            exit 0
            ;;
        -*)
            echo "Unknown option: $1" >&2
            echo "Use -h or --help for usage information." >&2
            exit 1
            ;;
        *)
            target_session="${1:-$DEFAULT_SESSION_NAME}"
            ;;
    esac

    # If specific session requested, try to attach/create it
    if [[ -n "$1" && "$1" != "$DEFAULT_SESSION_NAME" ]]; then
        attach_or_create "$target_session"
    fi

    # Default behavior: try default session first, then any session, then create default
    if session_exists "$DEFAULT_SESSION_NAME"; then
        attach_or_create "$DEFAULT_SESSION_NAME"
    elif "$TMUX_BIN" has-session 2>/dev/null; then
        # Attach to first available session
        first_session=$(get_first_session)
        if [[ -n "$first_session" ]]; then
            echo "Attaching to existing session: $first_session"
            exec "$TMUX_BIN" attach-session -t "$first_session"
        fi
    else
        # No sessions exist, create default
        attach_or_create "$DEFAULT_SESSION_NAME"
    fi
}

# Run main function with all arguments
main "$@"
