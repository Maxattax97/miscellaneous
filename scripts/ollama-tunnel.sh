#!/usr/bin/env bash
# Tunnels Ollama from leviathan to localhost via entourage (maxocull.com)
#
# Usage: ./ollama-tunnel.sh [start|stop|status]
#
# Once running, Ollama is available at http://localhost:11434
# Set your minuet end_point to http://localhost:11434/v1/completions

LOCAL_PORT=11434
REMOTE_HOST=leviathan
REMOTE_PORT=11434
JUMP_HOST=entourage
PID_FILE="${XDG_RUNTIME_DIR:-/tmp}/ollama-tunnel.pid"

start_tunnel() {
    if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2> /dev/null; then
        echo "Tunnel already running (PID $(cat "$PID_FILE"))"
        return 0
    fi

    echo "Starting Ollama tunnel: localhost:${LOCAL_PORT} -> ${REMOTE_HOST}:${REMOTE_PORT} via ${JUMP_HOST}"
    ssh -f -N \
        -L "${LOCAL_PORT}:localhost:${REMOTE_PORT}" \
        -J "${JUMP_HOST}" \
        "${REMOTE_HOST}" \
        -o ServerAliveInterval=30 \
        -o ServerAliveCountMax=3 \
        -o ExitOnForwardFailure=yes

    # Grab the PID of the backgrounded ssh process
    pgrep -f "ssh.*-L ${LOCAL_PORT}:localhost:${REMOTE_PORT}.*${REMOTE_HOST}" > "$PID_FILE"

    if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2> /dev/null; then
        echo "Tunnel running (PID $(cat "$PID_FILE"))"
    else
        echo "Failed to start tunnel" >&2
        rm -f "$PID_FILE"
        return 1
    fi
}

stop_tunnel() {
    if [ -f "$PID_FILE" ]; then
        local pid
        pid=$(cat "$PID_FILE")
        if kill -0 "$pid" 2> /dev/null; then
            kill "$pid"
            echo "Tunnel stopped (PID $pid)"
        else
            echo "Stale PID file, cleaning up"
        fi
        rm -f "$PID_FILE"
    else
        echo "No tunnel running"
    fi
}

status_tunnel() {
    if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2> /dev/null; then
        echo "Tunnel running (PID $(cat "$PID_FILE"))"
        echo "Ollama available at http://localhost:${LOCAL_PORT}"
    else
        echo "Tunnel not running"
        rm -f "$PID_FILE" 2> /dev/null
    fi
}

case "${1:-start}" in
    start) start_tunnel ;;
    stop) stop_tunnel ;;
    status) status_tunnel ;;
    *)
        echo "Usage: $0 [start|stop|status]" >&2
        exit 1
        ;;
esac
