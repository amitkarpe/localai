# Plan: Long-term dependency bootstrap and /goal execution

Date: 2026-05-30

## 1) Target model stack (single-model day-1)
- Primary: `qwen2.5:1.5b-instruct`
- Local-first only on day-1
- No default API fallback

## 2) Required binaries / dependencies
- Required now:
  - `ollama`
  - `curl`
  - `node` (already present)
  - `opencode`
  - `codex`
- Nice-to-have (optional):
  - `hermes` (optional helper path)

## 3) Install plan
1. Mount/check storage
   - Confirm `/dev/sda4` and mount at `/mnt/ai`.
2. Install/validate Ollama
   - Install Ollama if missing.
   - Confirm `ollama --version`.
3. Start/verify runtime
   - Start local Ollama service and validate `curl http://localhost:11434/api/version`.
4. Configure model cache
   - Set `OLLAMA_MODELS=/mnt/ai/ollama-models`.
5. Pull model
   - `ollama pull qwen2.5:1.5b-instruct`.
6. Run 3 fixed prompts for gate testing.

## 4) Cross-repo evidence layout
- Durable shared run evidence: `~/.AGENTS-temp/localai-lab/`
- Per-repo evidence: `~/.AGENTS-temp/localai-lab/repos/<repo>/`
- Dependency installs/logs: `~/.AGENTS-temp/localai-lab/shared/install-logs/`

## 5) /goal execution how-to (for this lane)
- Since GOAL is actionable, use `goal` mode directly.
- Send in Codex pane:
  - `/goal localai long-running loop. Read /home/dev/.AGENTS-temp/localai/GOAL.md first. Use lane-local truth under /home/dev/.AGENTS-temp/localai unless repo files are explicitly named. Start with Phase 0 Probe, run MVP Proof next, and enter Full Lane only if gates pass. Stop on one clean result packet or blocker.`
- If the lane truth conflicts or no-go boundary is unclear, use `/plan` first.

## 6) Stop conditions
- No-go if no local runtime or storage mount.
- No-go if local validation gate fails (3 prompts fail).
- No default API fallback until local path passes.
