# WarpLocal

纯本地版 Warp 终端，移除所有云端依赖，AI 功能直连用户自己的 API。

基于 [Warp](https://github.com/warpdotdev/warp) 开源项目修改，对应依赖版本：
- **Rust toolchain:** 1.92.0
- **wgpu:** 29.0.1（GPU 渲染）
- **warp_multi_agent_api:** [9a2d242](https://github.com/warpdotdev/warp-proto-apis/commit/9a2d2425c5d1eb40fb547956e659511906e03f9e)（多智能体 API）
- **warp-workflows:** [793a98d](https://github.com/warpdotdev/workflows/commit/793a98ddda6ef19682aed66364faebd2829f0e01)（工作流引擎）
- **session-sharing-protocol:** [3a12b87](https://github.com/warpdotdev/session-sharing-protocol/commit/3a12b871dfd1019a66057e4d9b7d5c812b73ee8c)（会话共享协议）

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
curl --proto '=https.2 -sSf https://sh.rustup.rs | sh

# 编译（约 20-30 分钟）
MACOSX_DEPLOYMENT_TARGET=14.0 cargo build --release -p warp --bin warplocal
```

编译产物为 `target/release/warplocal`。

### 3. 安装（与原版 Warp 并排共存）

产物二进制名为 `warplocal`，Bundle ID 为 `dev.warp.WarpLocal`，可与原版 Warp 同时安装。

```bash
# 推荐：并排安装（不替换原版）
# 需要手动创建 .app bundle 目录结构，或使用 cargo-bundle 工具

# 编译完成后，产物在：
ls target/release/warplocal
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