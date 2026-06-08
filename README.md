# WarpLocal

[![Version](https://img.shields.io/badge/version-v0.2.0-blue.svg)](https://github.com/CyberYui/Warplocal/releases)
[![Platform](https://img.shields.io/badge/platform-macOS%2014%2B%20(Universal)-lightgrey.svg)](https://github.com/CyberYui/Warplocal/releases)
[![License](https://img.shields.io/badge/license-AGPL--3.0-green.svg)](./LICENSE)

A local-only fork of the [Warp](https://github.com/warpdotdev/warp) terminal. All cloud dependencies removed — AI features connect directly to your own LLM API.

## Features

- Local AI inference (OpenAI, DeepSeek, Ollama, or any OpenAI-compatible API)
- No cloud dependencies, no account required
- Persistent agent mode with context preservation
- Full terminal emulation with GPU rendering
- SSH support
- Works alongside the official Warp app

## Installation

### Download (Recommended)

Download the latest universal `.dmg` from [Releases](https://github.com/CyberYui/Warplocal/releases), open it, and drag `WarpLocal.app` to `/Applications`. Works on both Apple Silicon and Intel Macs.

> **Gatekeeper:** On first launch, right-click the app and select "Open" to bypass Gatekeeper.

### Build from Source

```bash
MACOSX_DEPLOYMENT_TARGET=14.0 cargo build --release -p warp --bin warplocal
```

The binary is at `target/release/warplocal`.

## Configuration

Create `~/.warplocal/config.toml`:

```toml
api_url = "https://api.deepseek.com/v1/chat/completions"
api_key = "your-api-key-here"
model = "deepseek-chat"
```

Or use environment variables:

```bash
export WARP_LOCAL_API_URL="https://api.deepseek.com/v1/chat/completions"
export WARP_LOCAL_API_KEY="your-api-key-here"
export WARP_LOCAL_MODEL="deepseek-chat"
```

## Supported APIs

| Provider | URL | Model |
|----------|-----|-------|
| OpenAI | `https://api.openai.com/v1/chat/completions` | `gpt-4o` |
| DeepSeek | `https://api.deepseek.com/v1/chat/completions` | `deepseek-chat` |
| Ollama | `http://localhost:11434/v1/chat/completions` | `qwen2.5` |

## Project Structure

```
app/           — Main application (terminal, AI, settings)
crates/        — Shared libraries (UI framework, editor, completer, etc.)
resources/     — Bundled config templates
ui/            — WarpUI framework source (MIT license)
scripts/       — Build & packaging scripts
```

## Requirements

- macOS 14.0+
- Apple Silicon or Intel
- An OpenAI-compatible LLM API

## License

AGPL-3.0. Based on the [Warp](https://github.com/warpdotdev/warp) open-source project. The UI framework crates (`ui/`) remain under MIT.
