# ============================================
#  winutil 一键编译 + 启动
#  用法：双击 build-run.bat 或在 PowerShell 中执行本脚本
# ============================================
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

Write-Host ""
Write-Host "======================================"
Write-Host "  winutil 编译并启动"
Write-Host "======================================"
Write-Host ""

Write-Host "[1/2] 正在编译 winutil.ps1 ..."
try {
    & .\Compile.ps1
} catch {
    Write-Host "编译失败: $($_.Exception.Message)" -ForegroundColor Red
    Read-Host "按回车键退出"
    exit 1
}
Write-Host "[1/2] 编译完成" -ForegroundColor Green

Write-Host "[2/2] 正在启动 winutil（如弹出管理员授权提示，请点击“是”）..."
& .\winutil.ps1

Write-Host ""
Write-Host "winutil 已退出。"
