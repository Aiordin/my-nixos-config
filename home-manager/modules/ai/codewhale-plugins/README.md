# Codewhale 插件

放在这里的每个子目录会由 Home Manager 复制到 `~/.codewhale/plugins/<name>/`
（Codewhale 拒绝符号链接形式的插件根，所以是复制而不是链接）。

## 目录结构

```
codewhale-plugins/
└── my-plugin/
    ├── plugin.json          # 或 plugin.toml / kimi.plugin.json / .claude-plugin/plugin.json
    └── skills/
        └── my-skill/
            └── SKILL.md
```

最小 `plugin.json`（Agent Plugins v1.0.0）：

```json
{
  "$schema": "https://agent-plugins.org/schemas/plugin.json",
  "name": "my-plugin",
  "version": "0.1.0",
  "description": "What this bundle provides",
  "extensions": {
    "net.codewhale": {
      "skills": { "path": "skills" }
    }
  }
}
```

> `skills/` 位于 bundle 根时会被自动发现，`extensions["net.codewhale"]` 可省略。

## 启用

复制到磁盘不等于启用。switch 之后在 Codewhale TUI 里执行：

```
/plugin list
/plugin trust <name> <content-hash>.<capability-hash>
/plugin enable <name>
```

`/plugin trust` 的 token 由 `/plugin enable` 的审查界面给出，绑定当前内容哈希。
内容不变时重新 switch 不会让 trust 失效；内容变了需要重新审查。

## 安装现成插件

```sh
codewhale install git:github.com/owner/plugin@v1.0.0   # 0.10.1+ 的 CLI
```

或 TUI 内 `/plugin install <spec>`。安装后用 `/plugin export <name> <dir>` 可以
导出成规范目录，再放进这里做声明式管理。
