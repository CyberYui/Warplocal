# WarpLocal — 纯本地版 Warp

## 是什么
Warp 终端的本地版分支，移除了所有云端依赖。AI 功能直连用户自己配置的大模型 API，无需付费给 Warp。

## 改了哪些源码

### 1. Feature Flag 硬编码开启
**文件：** `crates/warp_features/src/lib.rs`
- 新增 `ALWAYS_ENABLED_FEATURES` 常量，包含：
  - `SoloUserByok` — 允许 solo 用户使用 BYO API key
  - `CustomInferenceEndpoints` — 自定义推理端点 UI
  - `CustomInferenceEndpointsEnterprise` — 企业自定义推理端点
- 在 `is_enabled()` 中优先检查该列表，强制返回 `true`
- 同时强制禁用 `ForceLogin`、`FreeUserNoAi`、`SkipFirebaseAnonymousUser`

### 2. 移除登录/工作区检查
**文件：** `app/src/workspaces/user_workspaces.rs`
- `is_byo_api_key_enabled()` → 永远返回 `true`
- `is_custom_inference_enabled()` → 永远返回 `true`

### 3. 添加本地 AI 推理
**文件：** `app/src/server/server_api/ai.rs`
新增核心函数：
- `is_local_inference_enabled()` — 永远返回 `true`（本地推理始终开启）
- `call_local_llm()` — 调用用户配置的 OpenAI 兼容 API
- `call_local_llm_with_model()` — 支持 per-model endpoint override
- `call_llm_direct()` — 直接调用指定端点（Agent Mode 路由用）
- `load_local_ai_config()` — 从 `~/.warplocal/config.toml` 或环境变量读取配置

被修改的 AI 方法：
| 方法 | 改动 |
|---|---|
| `generate_dialogue_answer` | 对话 → 走本地 LLM |
| `generate_commands_from_natural_language` | NL→命令 → 走本地 LLM |
| `generate_metadata_for_command` | 元数据 → 返回空 |
| `get_request_limit_info` | 返回无限额度 |
| `get_feature_model_choices` | 返回默认模型 |
| `get_available_harnesses` | 返回空列表 |

## 配置方式

### 方法 1：配置文件（推荐）
在 `~/.warplocal/config.toml` 中配置：

```toml
# WarpLocal AI 配置
# 支持任何 OpenAI 兼容的 API

api_url = "https://api.deepseek.com/v1/chat/completions"
api_key = "your-api-key-here"  # 替换为你的实际API密钥
model = "deepseek-chat"
```

**注意：** `config.toml` 已在 `.gitignore` 中，不会被提交到版本控制。

### 方法 2：环境变量
```bash
export WARP_LOCAL_API_URL="https://api.deepseek.com/v1/chat/completions"
export WARP_LOCAL_API_KEY="your-api-key-here"
export WARP_LOCAL_MODEL="deepseek-chat"
```

### 支持的 API
- **OpenAI:** `https://api.openai.com/v1/chat/completions` + `gpt-4o`
- **DeepSeek:** `https://api.deepseek.com/v1/chat/completions` + `deepseek-chat`
- **本地 Ollama:** `http://localhost:11434/v1/chat/completions` + `qwen2.5`

## 如何编译

### 前置条件
```bash
# 1. 安装 Rust（如果没装）
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# 2. 配置国内镜像加速（可选，国内网络推荐）
mkdir -p ~/.cargo
cat > ~/.cargo/config.toml << 'EOF'
[source.crates-io]
replace-with = "ustc"
[source.ustc]
registry = "sparse+https://mirrors.ustc.edu.cn/crates.io-index/"
EOF
```

### 编译
```bash
cd ~/Documents/GitHub/Warplocal
# Release 编译（约 20-30 分钟）
cargo build --release -p app --bin warplocal
```

编译产物为 `target/release/warplocal`。

### 安装（与原版 Warp 并排共存）
产物二进制名已改为 `warplocal`，bundle ID 为 `dev.warp.WarpLocal`，可与原版 Warp 同时安装：

```bash
# 方式 1：直接替换原版（不推荐，除非你不需要原版）
cp -r /Applications/Warp.app /Applications/Warp.app.bak
cp target/release/warplocal /Applications/Warp.app/Contents/MacOS/warplocal

# 方式 2：并排安装（推荐）
# 需要手动创建 .app  bundle 目录结构，将 warplocal 二进制放入
# 并使用 [package.metadata.bundle.bin.warplocal] 中配置的标识符
```

> 当前配置：二进制名 `warplocal`，Bundle ID `dev.warp.WarpLocal`，显示名 `WarpLocal`

## 注意事项
- 原版 Warp 不受影响
- SSH 连接功能正常工作（不走云）
- OpenCode、Copilot CLI、Claude Code 等终端 CLI 工具完全正常
- 自动更新需要手动合并上游代码后重新编译
