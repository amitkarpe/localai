#!/usr/bin/env bash
set -euo pipefail

MODEL_NAME="${LOCALAI_MODEL_NAME:-qwen2.5:1.5b-instruct}"
MOUNT_POINT="/mnt/ai"
REQUIRED_DEVICE="/dev/sda4"
OLLAMA_MODELS_DIR="${OLLAMA_MODELS:-${MOUNT_POINT}/ollama-models}"
OLLAMA_HOST="${OLLAMA_HOST:-127.0.0.1:11434}"
OLLAMA_API="http://${OLLAMA_HOST}/api"
LOG_DIR="$(cd "$(dirname "$0")/../.." && pwd)/logs/local"

usage() {
  cat <<'USAGE'
Usage:
  localai-day1.sh probe
  localai-day1.sh preflight
  localai-day1.sh run "<prompt>"
  localai-day1.sh run-json "<prompt>"

Commands:
  preflight  Validate local mount, runtime, and approved model presence.
  probe      Run the 3 fixed prompts used for MVP acceptance gate.
  run       Call local model directly. Example:
            localai-day1.sh run "Hello"
  run-json  Call local model and require valid JSON response. Example:
            localai-day1.sh run-json '{"task":"healthcheck"}'

Environment:
  LOCALAI_MODEL_NAME  default qwen2.5:1.5b-instruct
  OLLAMA_HOST         default 127.0.0.1:11434
  OLLAMA_MODELS       default /mnt/ai/ollama-models

Policy:
  No automatic external/API fallback is implemented in this script.
USAGE
}

require_jq() {
  if ! command -v jq >/dev/null 2>&1; then
    echo "required dependency missing: jq" >&2
    exit 2
  fi
}

log() {
  printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S%z')" "$*"
}

strip_code_fences() {
  local text="$1"
  awk '
    {
      original[++original_count] = $0
    }
    /^[[:space:]]*```/ {
      if (!inside_fence) {
        inside_fence = 1
        next
      }
      for (i = 1; i <= fenced_count; i++) {
        print fenced[i]
      }
      closed_fence = 1
      exit
    }
    inside_fence {
      fenced[++fenced_count] = $0
    }
    END {
      if (!closed_fence) {
        for (i = 1; i <= original_count; i++) {
          print original[i]
        }
      }
    }
  ' <<<"$text"
}

json_val() {
  local json="$1"
  local filter="$2"
  jq -r "$filter" <<<"$json"
}

check_mount() {
  if [ ! -d "$MOUNT_POINT" ]; then
    log "FAIL: mountpoint missing: $MOUNT_POINT"
    return 1
  fi

  if command -v mountpoint >/dev/null 2>&1; then
    if ! mountpoint -q "$MOUNT_POINT"; then
      log "FAIL: ${MOUNT_POINT} exists but is not mounted"
      return 1
    fi
  elif command -v findmnt >/dev/null 2>&1; then
    current=$(findmnt -n -o SOURCE "$MOUNT_POINT" || true)
    if [ -z "${current}" ]; then
      log "FAIL: mount check failed for ${MOUNT_POINT}"
      return 1
    fi
  fi

  if command -v findmnt >/dev/null 2>&1; then
    source=$(findmnt -n -o SOURCE "$MOUNT_POINT" || true)
    if [ -n "$source" ] && [ "$source" != "$REQUIRED_DEVICE" ]; then
      log "FAIL: ${MOUNT_POINT} is on ${source}, expected ${REQUIRED_DEVICE}"
      return 1
    fi
  fi

  if [ ! -d "$OLLAMA_MODELS_DIR" ]; then
    log "INFO: creating model directory ${OLLAMA_MODELS_DIR}"
    mkdir -p "$OLLAMA_MODELS_DIR"
  fi

  log "PASS: storage check (${MOUNT_POINT} on ${REQUIRED_DEVICE})"
  return 0
}

check_runtime() {
  if ! curl -sS --max-time 3 "${OLLAMA_API}/version" >/tmp/localai-version.json; then
    log "FAIL: ollama runtime unreachable at ${OLLAMA_API}"
    return 1
  fi
  version=$(json_val "$(cat /tmp/localai-version.json)" '.version // "unknown"')
  log "PASS: ollama reachable (version ${version})"
}

check_model() {
  models="$(curl -sS --max-time 6 "${OLLAMA_API}/tags")"
  if ! grep -q "\"${MODEL_NAME}\"" <<<"$models"; then
    log "FAIL: approved model missing from local registry: ${MODEL_NAME}"
    return 1
  fi
  log "PASS: approved model present (${MODEL_NAME})"
}

preflight() {
  log "Starting LocalAI Day-1 preflight"
  require_jq
  mkdir -p "$LOG_DIR"
  if ! check_mount; then
    return 1
  fi
  if ! check_runtime; then
    return 1
  fi
  if ! check_model; then
    return 1
  fi
  log "PASS: preflight complete"
}

run_prompt() {
  local prompt="$1"
  local payload
  payload=$(jq -cn --arg m "$MODEL_NAME" --arg p "$prompt" '{model:$m,prompt:$p,stream:false}')
  curl -sS --max-time 60 -H 'Content-Type: application/json' -d "$payload" "${OLLAMA_API}/generate"
}

run_prompt_json() {
  local prompt="$1"
  local raw_json
  raw_json=$(run_prompt "$prompt")
  strip_code_fences "$raw_json"
}

run_probe() {
  if ! preflight; then
    log "No-go: preflight failed"
    return 1
  fi

  local pass=0
  local prompt1="What is 12 * 13? Answer with only a number."
  local prompt2="Reply in one sentence: one practical reason to run AI locally on a small machine."
  local prompt3="Give one short privacy risk if local model artifacts are stored on a shared mount and one mitigation."

  run_and_eval() {
    local n="$1"
    local prompt="$2"
    local response_json
    local response
    if ! response_json="$(run_prompt "$prompt")"; then
      response=""
      case "$n" in
        1) echo "Prompt $n FAIL (generate timeout/error)";;
        2) echo "Prompt $n FAIL (generate timeout/error)";;
        3) echo "Prompt $n FAIL (generate timeout/error)";;
      esac
      return
    fi
    response="$(json_val "$response_json" '.response // empty')"

    case "$n" in
      1)
        if [ "$(echo "$response" | tr -d '[:space:]')" = "156" ]; then
          pass=$((pass + 1))
          echo "Prompt $n PASS"
        else
          echo "Prompt $n FAIL (expected exact 156)"
        fi
        ;;
      2)
        if [ -n "$response" ] && [ "$(echo "$response" | wc -w)" -gt 2 ]; then
          pass=$((pass + 1))
          echo "Prompt $n PASS"
        else
          echo "Prompt $n FAIL (non-empty sentence required)"
        fi
        ;;
      3)
        low=$(echo "$response" | tr '[:upper:]' '[:lower:]')
        if [ -n "$response" ] && grep -Eq "risk|privacy|expose|access|permission|mitig|encrypt" <<<"$low" && grep -Eq "mitig|access|encrypt|permission|encrypt" <<<"$low"; then
          pass=$((pass + 1))
          echo "Prompt $n PASS"
        else
          echo "Prompt $n FAIL (risk/mitigation coverage required)"
        fi
        ;;
    esac
  }

  run_and_eval 1 "$prompt1"
  run_and_eval 2 "$prompt2"
  run_and_eval 3 "$prompt3"

  log "MVP gate result: ${pass}/3"
  printf '%s\n' "$pass" > "${LOG_DIR}/localai-day1-gate-pass-count.txt"
  if [ "$pass" -ne 3 ]; then
    return 1
  fi
}

infer() {
  local prompt="$*"
  if [ -z "$prompt" ]; then
    echo "Error: prompt is required for infer" >&2
    usage
    return 1
  fi
  preflight || return 1
  run_prompt "$prompt" | jq -r '.response // ""'
}

infer_json() {
  local prompt="$*"
  if [ -z "$prompt" ]; then
    echo "Error: prompt is required for infer-json" >&2
    usage
    return 1
  fi
  preflight || return 1
  local response response_text
  response=$(run_prompt "$prompt")
  response_text=$(jq -r '.response // ""' <<<"$response")
  response_text=$(strip_code_fences "$response_text")
  if ! jq -e '.' <<<"$response_text" >/dev/null 2>&1; then
    echo "Error: model response is not valid JSON after sanitation" >&2
    return 1
  fi
  echo "$response_text"
}

main() {
  case "${1:-probe}" in
    preflight)
      preflight
      ;;
    probe)
      run_probe
      ;;
    run)
      shift
      infer "$@"
      ;;
    run-json)
      shift
      infer_json "$@"
      ;;
    -h|--help|help)
      usage
      ;;
    *)
      usage
      return 1
      ;;
  esac
}

main "$@"
