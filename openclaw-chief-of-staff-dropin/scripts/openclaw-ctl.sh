#!/bin/bash
# OpenClaw Gateway Control Script
# Usage: ./scripts/openclaw-ctl.sh [start|stop|restart|status]

set -e

# Resolve script directory (works even with symlinks)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PORT=18789

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

check_status() {
    # Check if gateway is responding
    if curl -s --max-time 2 "http://127.0.0.1:$PORT/health" > /dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

get_pid() {
    # Find openclaw gateway process
    pgrep -f "openclaw.*gateway" 2>/dev/null || pgrep -f "node.*gateway" 2>/dev/null | head -1 || echo ""
}

show_status() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🦞 OpenClaw Gateway Status"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    if check_status; then
        log_success "Gateway is RUNNING on port $PORT"
        
        # Get more details
        local pid=$(get_pid)
        if [ -n "$pid" ]; then
            log_info "PID: $pid"
        fi
        
        # Check launchctl status
        if launchctl list 2>/dev/null | grep -q "openclaw"; then
            log_info "LaunchAgent: Active"
        fi
        
        echo ""
        log_info "Dashboard: http://127.0.0.1:$PORT"
        return 0
    else
        log_error "Gateway is NOT RUNNING"
        return 1
    fi
}

stop_gateway() {
    log_info "Stopping OpenClaw gateway..."
    
    # Try launchctl first
    if launchctl list 2>/dev/null | grep -q "ai.openclaw.gateway"; then
        launchctl bootout gui/$(id -u)/ai.openclaw.gateway 2>/dev/null || true
        log_info "Stopped LaunchAgent"
    fi
    
    # Kill any remaining processes
    pkill -9 -f "openclaw.*gateway" 2>/dev/null || true
    pkill -9 -f "node.*run-node.*gateway" 2>/dev/null || true
    
    sleep 1
    
    if check_status; then
        log_warn "Gateway still responding, force killing..."
        lsof -ti:$PORT | xargs kill -9 2>/dev/null || true
        sleep 1
    fi
    
    if ! check_status; then
        log_success "Gateway stopped"
    else
        log_error "Failed to stop gateway"
        return 1
    fi
}

start_gateway() {
    log_info "Starting OpenClaw gateway..."
    
    # Check if already running
    if check_status; then
        log_warn "Gateway already running"
        show_status
        return 0
    fi
    
    # Try launchctl first (preferred for persistence)
    if [ -f ~/Library/LaunchAgents/ai.openclaw.gateway.plist ]; then
        log_info "Starting via LaunchAgent..."
        launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/ai.openclaw.gateway.plist 2>/dev/null || \
        launchctl kickstart -k gui/$(id -u)/ai.openclaw.gateway 2>/dev/null || true
    else
        # Fallback: run gateway directly
        log_info "Starting gateway directly..."
        if command -v openclaw >/dev/null 2>&1; then
            nohup openclaw gateway run --port "$PORT" --bind loopback > /tmp/openclaw-gateway.log 2>&1 &
        elif command -v pnpm >/dev/null 2>&1 && [ -f "$SCRIPT_DIR/../../package.json" ]; then
            (
                cd "$SCRIPT_DIR/../.."
                nohup pnpm openclaw gateway run --port "$PORT" --bind loopback > /tmp/openclaw-gateway.log 2>&1 &
            )
        else
            log_error "Could not find openclaw CLI"
            log_info "Install OpenClaw or run this script from an OpenClaw repo checkout."
            return 1
        fi
    fi
    
    # Wait for gateway to start
    log_info "Waiting for gateway to start..."
    for i in {1..15}; do
        sleep 1
        if check_status; then
            echo ""
            log_success "Gateway started successfully!"
            show_status
            return 0
        fi
        echo -n "."
    done
    
    echo ""
    log_error "Gateway failed to start within 15 seconds"
    log_info "Check logs: tail -50 /tmp/openclaw-gateway.log"
    tail -20 /tmp/openclaw-gateway.log 2>/dev/null || true
    return 1
}

restart_gateway() {
    log_info "Restarting OpenClaw gateway..."
    stop_gateway
    sleep 2
    start_gateway
}

# Main
case "${1:-status}" in
    start)
        start_gateway
        ;;
    stop)
        stop_gateway
        ;;
    restart)
        restart_gateway
        ;;
    status)
        show_status
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status}"
        echo ""
        echo "Commands:"
        echo "  start    - Start the OpenClaw gateway"
        echo "  stop     - Stop the OpenClaw gateway"
        echo "  restart  - Restart the OpenClaw gateway"
        echo "  status   - Check gateway status (default)"
        exit 1
        ;;
esac
