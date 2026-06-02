# WarpLocal

纯本地版 Warp 终端，移除所有云端依赖，AI 功能直连用户自己的 API。

## 特性

- 本地 AI 推理（支持 OpenAI、DeepSeek、Ollama 等）
- 无云端依赖，无需付费
- 完整的终端功能
- SSH 连接正常工作

## 快速开始

### 1. 配置 API

在 `~/.warplocal/config.toml` 中配置：

```toml
api_url = "https://api.deepseek.com/v1/chat/completions"
api_key = "your-api-key-here"
model = "deepseek-chat"
```

或使用环境变量：

```bash
export WARP_LOCAL_API_URL="https://api.deepseek.com/v1/chat/completions"
export WARP_LOCAL_API_KEY="your-api-key-here"
export WARP_LOCAL_MODEL="deepseek-chat"
```

**重要：** 
- `config.toml` 已在 `.gitignore` 中，不会被提交到版本控制
- 请勿将API密钥硬编码到代码中
- 使用环境变量或配置文件管理敏感信息

### 2. 编译

```bash
# 安装 Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# 编译
cargo build --release -p app
```

### 3. 安装

```bash
# 备份原版
cp -r /Applications/Warp.app /Applications/Warp.app.bak

# 替换
cp target/release/Warp /Applications/Warp.app/Contents/MacOS/Warp
```

## 支持的 API

- **OpenAI:** `https://api.openai.com/v1/chat/completions` + `gpt-4o`
- **DeepSeek:** `https://api.deepseek.com/v1/chat/completions` + `deepseek-chat`
- **本地 Ollama:** `http://localhost:11434/v1/chat/completions` + `qwen2.5`

## 许可证

本项目基于 [AGPL-3.0](LICENSE-AGPL) 许可证。

### 致谢

本项目基于 [Warp](https://github.com/warpdotdev/warp) 开源项目修改而成。

- 原版 Warp UI 框架 (warpui_core, warpui) 基于 [MIT 许可证](LICENSE-MIT)
- 其余代码基于 [AGPL-3.0 许可证](LICENSE-AGPL)
- 感谢 Warp 团队的开源贡献

## 免责声明

本项目是 Warp 终端的本地化修改版本，与 Warp 官方无关。