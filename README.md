# winutil-cn —— Windows 开发者工具箱（中文增强版）

> 基于 [ChrisTitusTech/winutil](https://github.com/ChrisTitusTech/winutil)（`v26.08.15` 基线）的中文汉化 + 国内开发者环境增强分支。
> 保留原项目的全部功能：软件一键安装、系统优化（Tweaks）、系统功能配置（Config）、Windows 更新管理、Win11 ISO 制作、预装应用（AppX）管理。

---

## 一、与原仓库的差异

### 1. 新增功能

| 功能 | 说明 |
|---|---|
| **OpenJDK 17 (LTS)** | 安装页新增 Temurin 17（国内企业主流版本，原仓库只有 8/21/25） |
| **Apache Maven** | 安装页新增 Maven（原仓库没有） |
| **开发环境配置分类** | 「优化」页新增 5 项一键配置（均可撤销）：npm/pnpm/yarn 国内镜像、pip 清华源、Maven 阿里云镜像、Git 全局配置、VS Code 常用扩展 |
| **自定义安装目录** | 支持给指定工具配置自定义安装路径（`--location`），见下文「自定义安装目录」 |

### 2. 界面全面汉化

- 全部页签标题（安装/优化/配置/更新）、应用分类树、筛选分类、操作按钮
- 设置弹窗（导入/导出/关于/文档/赞助商）、主题菜单、右键菜单
- 优化页分类（基础优化/个性化偏好/电源计划/高级优化）、配置页全部分类与条目、AppX 页分类
- 动态文本（"已选应用: N" 等）

### 3. Bug 修复（相对原仓库）

| 修复 | 说明 |
|---|---|
| **切页逻辑适配汉化** | 原版以页面标题（Header）作为内部逻辑名；汉化后标题为中文，通过 Header→逻辑名映射保证页签切换与内容初始化正常 |
| **"查看已安装"报错** | 原版在控件未创建时直接设置 `IsChecked` 会抛"找不到属性"，已加判空保护 |
| **编译产物编码** | `Compile.ps1` 输出改为 UTF-8 with BOM，保证含中文的打包产物在任何 PowerShell 版本下正确解码 |

---

## 二、环境要求

- Windows 10 / 11
- PowerShell 5.1 或更高（无需额外安装，系统自带）
- 需要**管理员权限**（winutil 会自动弹出 UAC 提权）

---

## 三、快速启动

### 方式一：一键脚本（推荐）

双击仓库根目录的 **`build-run.bat`**，自动完成「编译 + 启动」，改过配置后也用它，无需记命令。

### 方式二：命令行

```powershell
cd D:\aiWork\tools\winutil
Set-ExecutionPolicy Bypass -Scope Process   # 仅当前窗口放开脚本执行限制
.\winutil.ps1
```

### 方式三：无源码直接运行（原版方式，不含本分支改动）

```powershell
irm https://christitus.com/win | iex
```

> ⚠️ 方式三拉取的是官方原版，**不包含本项目的汉化与新增功能**，仅用于体验原版。

---

## 四、使用说明

### 1. 安装开发者工具

「安装」页 → 左侧分类选「开发」→ 勾选工具（JDK 17/21、Python、Node.js、Git、Maven、VS Code…）→ 点「安装所选」。

- 默认使用 winget 安装（也可在左侧选择 Chocolatey）
- 自动检测已安装的软件并跳过，失败自动重试并写日志

### 2. 装后一键配置（本项目核心增强）

「优化」页 → 「开发环境配置」分类 → 勾选后点「执行优化」：

| 配置项 | 作用 |
|---|---|
| npm/pnpm/yarn 国内镜像 (npmmirror) | registry / electron / node-sass 镜像，大幅加速前端依赖安装 |
| pip 国内镜像 (清华源) | PyPI 镜像，加速 Python 包安装 |
| Maven 国内镜像 (阿里云) | 生成 `~/.m2/settings.xml`，加速 Java 依赖下载 |
| Git 全局配置 | autocrlf、默认分支 main、推送策略、凭据管理器（user.name/email 需自行设置） |
| VS Code 常用扩展 | 中文语言包、GitLens、ESLint、Prettier、Python、Java、Docker 等 10 个扩展 |

所有配置项均支持「撤销所选优化」一键还原。

### 3. 自定义安装目录

编辑 `config/applications.json`，给目标工具加 `installLocation` 字段，然后重新编译运行（见下文「开发者」）：

```json
"java17": {
    "category": "开发",
    "choco": "temurin17jdk",
    "content": "OpenJDK 17 (LTS)",
    "description": "Eclipse Temurin 17 (LTS) is a popular, no-cost OpenJDK distribution widely used in enterprise Java development.",
    "link": "https://adoptium.net/",
    "winget": "EclipseAdoptium.Temurin.17.JDK",
    "foss": true,
    "installLocation": "D:\\dev\\tools\\jdk17"
}
```

- 仅对支持自定义目录的安装器生效（已验证：Temurin/Corretto JDK、Maven、Node.js）
- 不支持的包会忽略该参数或安装失败，删除该字段即可
- JDK 装到自定义目录后需自行配置 `JAVA_HOME`（winutil 不自动配置环境变量）

### 4. 日志位置

```
%LOCALAPPDATA%\winutil\logs\winutil_<时间戳>.log
```

---

## 五、开发者指南

### 编译（生成 winutil.ps1 单文件）

```powershell
.\Compile.ps1
```

产物 `winutil.ps1` 为自包含单文件（脚本 + 配置 + 界面全部内嵌），被 `.gitignore` 忽略，不入库。

### 运行测试（Pester 5+）

```powershell
Install-Module Pester -Force -Scope CurrentUser -SkipPublisherCheck -MinimumVersion 5.5.0
Invoke-Pester -Path pester
```

- 基线：541 通过 / 11 失败（11 个失败为 `winoneshot-compat` 测试在 PowerShell 5.1 下的环境限制，需 PS 7.3+ 的 `-NoEnumerate`，与本分支改动无关）

### ⚠️ 编码规范（重要）

- **含中文的 `.ps1` / `.json` / `.xaml` 源文件必须保存为 UTF-8 with BOM**，否则 PowerShell 5.1 下 `Compile.ps1` 会按 GBK 解码导致中文乱码（本分支曾因此出现界面空白 bug）
- `.bat` 文件必须用 CRLF 换行 + 纯 ASCII
- 修改含中文文件后，建议重新编译并抽查产物中的中文是否正常：
  ```powershell
  Select-String -Path winutil.ps1 -Pattern '配置' | Select-Object -First 3
  ```

### 目录结构

```
winutil/
├── Compile.ps1                 # 编译脚本（输出 UTF-8 BOM 产物）
├── build-run.bat / .ps1        # 一键编译 + 启动（本分支新增）
├── winutil.ps1                 # 编译产物（gitignore，不入库）
├── config/                     # 数据配置（应用清单/优化项/系统功能等，均被汉化）
│   ├── applications.json       # 应用清单（含 installLocation 可选字段）
│   ├── tweaks.json             # 优化项（含「开发环境配置」分类）
│   ├── feature.json            # 配置页（系统功能）
│   ├── appnavigation.json      # 安装页左侧操作区
│   ├── appx.json               # AppX 应用管理
│   └── ...
├── scripts/                    # 入口与主逻辑（start.ps1 / main.ps1）
├── functions/                  # 功能函数（public / private）
│   └── private/Get-WinUtilInstallLocation.ps1   # 自定义安装目录查询（本分支新增）
├── xaml/inputXML.xaml          # WPF 界面（已汉化）
└── pester/                     # 测试
```

---

## 六、已知限制

- 「配置」页的系统功能开关（.NET/Hyper-V/WSL 等）需要管理员权限，部分功能启用后需重启
- VS Code 扩展安装依赖 VS Code 默认安装位置（`LocalAppData` 或 `Program Files`），自定义安装路径需自行调整脚本
- 应用条目名称保留英文（作为搜索匹配依据，同时更准确）

---

## 七、免责声明

本项目为个人学习与使用目的 fork 分支，与 Chris Titus Tech 官方无关联。使用系统优化与安装功能前请自行评估风险，修改系统设置可能影响系统稳定性。

- 原仓库：https://github.com/ChrisTitusTech/winutil
- 原仓库文档：https://winutil.christitus.com/
