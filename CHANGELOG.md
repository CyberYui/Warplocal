# Changelog

## WarpLocal v0.1.0

### What's New
- Initial release of WarpLocal
- Local AI inference via your own LLM API (OpenAI, DeepSeek, Ollama, or any OpenAI-compatible endpoint)
- Full terminal emulation with GPU rendering
- Agent mode with persistent context across conversations
- SSH support

### Requirements
- macOS 14.0+ (Apple Silicon)
- An OpenAI-compatible LLM API

### Installation
1. Download `WarpLocal-v0.1.0-aarch64.dmg`
2. Open the DMG and drag `WarpLocal.app` to `/Applications`
3. Launch WarpLocal and configure your API in `~/.warplocal/config.toml`

### Known Issues
- First launch may require right-click > Open to bypass Gatekeeper
