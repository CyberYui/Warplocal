# WarpLocal

WarpLocal is a local-only fork of the [Warp](https://github.com/warpdotdev/warp) terminal. It removes all cloud dependencies and connects AI features directly to your own LLM API.

## Features

- Local AI inference (OpenAI, DeepSeek, Ollama, or any OpenAI-compatible API)
- No cloud dependencies, no account required
- Full terminal emulation with GPU rendering
- SSH support
- Works alongside the official Warp app

## Quick Start

### 1. Configure API

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

### 2. Build

```bash
MACOSX_DEPLOYMENT_TARGET=14.0 cargo build --release -p warp --bin warplocal
```

### 3. Install

The binary is at `target/release/warplocal`. Bundle ID is `dev.warp.WarpLocal` — install it as a separate `.app` bundle to run alongside the official Warp.

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
```

## License

AGPL-3.0. Based on the [Warp](https://github.com/warpdotdev/warp) open-source project. The UI framework crates (`ui/`) remain under MIT.
