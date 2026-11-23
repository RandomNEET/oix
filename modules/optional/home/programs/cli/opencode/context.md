# 通用规则

## 语言

- 默认使用简体中文交流，包括进度说明和最终回复
- 代码标识符、命令、报错和技术名称保留原文
- 提交说明遵循项目现有约定

## 代码注释

- 注释保持简短直接，使用短语，省略标点
- 保留代码标识符、命令和工具指令所需的符号

## Git 提交

- 为 AI 辅助完成的改动创建提交时，在提交信息末尾空一行，根据当前工具添加共同作者署名：
  - **Antigravity**: `Co-authored-by: Antigravity (<当前模型名称>) <noreply@google.com>`
  - **Codex**: `Co-authored-by: Codex (<当前模型名称>) <noreply@openai.com>`
  - **OpenCode**: `Co-authored-by: OpenCode (<当前模型名称>) <noreply@opencode.ai>`
  - **Pi**: `Co-authored-by: Pi (<当前模型名称>) <noreply@pi.dev>`
  - _(若无法获取具体模型名，则省略括号及模型名)_
- 保留已有共同作者信息，避免重复添加
- 保留用户原有的 Git 作者身份
