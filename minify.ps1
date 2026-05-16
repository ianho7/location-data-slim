# 压缩项目下所有 JSON 文件的 array（格式化 → 单行）
# 用法：在项目根目录执行，或修改 $rootPath

$rootPath = "."  # 改成你的项目路径，如 "C:\projects\myapp"

Get-ChildItem -Path $rootPath -Recurse -Filter "*.json" | ForEach-Object {
    $file = $_
    try {
        $content = Get-Content $file.FullName -Raw -Encoding UTF8
        $json = $content | ConvertFrom-Json

        # 判断根节点是否为 array
        if ($json -is [System.Array]) {
            $minified = $json | ConvertTo-Json -Depth 100 -Compress
            [System.IO.File]::WriteAllText($file.FullName, $minified, [System.Text.Encoding]::UTF8)
            Write-Host "✓ 压缩: $($file.FullName)" -ForegroundColor Green
        } else {
            Write-Host "- 跳过 (非 array): $($file.Name)" -ForegroundColor DarkGray
        }
    } catch {
        Write-Host "✗ 错误: $($file.Name) — $_" -ForegroundColor Red
    }
}

Write-Host "`n完成！" -ForegroundColor Cyan