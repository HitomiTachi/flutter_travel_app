# Script cai dat Visual Studio Components cho Flutter Windows Development
# Chay script nay voi quyen Administrator
# 
# Cach chay:
# 1. Mo PowerShell voi quyen Administrator (nhap chuot phai PowerShell -> Run as Administrator)
# 2. Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser (neu can, chi chay lan dau)
# 3. cd vao thu muc flutter_travel_app
# 4. Chay script:
#    - Tu dong cai dat (khong can tuong tac): .\install_visual_studio_components.ps1 -Quiet
#    - Huong dan thu cong (mo Visual Studio Installer): .\install_visual_studio_components.ps1

param(
    [switch]$Quiet = $false
)

Write-Host "=== Script cai dat Visual Studio Components cho Flutter ===" -ForegroundColor Cyan
Write-Host ""

$vsInstallerPath = "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vs_installer.exe"
$vswherePath = "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"

# Kiem tra Visual Studio Installer
if (-not (Test-Path $vsInstallerPath)) {
    Write-Host "[ERROR] Khong tim thay Visual Studio Installer!" -ForegroundColor Red
    Write-Host "Vui long cai dat Visual Studio truoc. Tai tai: https://visualstudio.microsoft.com/downloads/" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Hoac cai dat Visual Studio Build Tools:" -ForegroundColor Yellow
    Write-Host "  https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022" -ForegroundColor White
    exit 1
}

Write-Host "[OK] Tim thay Visual Studio Installer" -ForegroundColor Green

# Tim Visual Studio instance
$vsInstanceId = $null
$vsInstallationPath = $null

if (Test-Path $vswherePath) {
    $vsInstanceId = & $vswherePath -latest -property instanceId 2>$null
    $vsInstallationPath = & $vswherePath -latest -property installationPath 2>$null
}

if ($vsInstanceId -and $vsInstallationPath) {
    Write-Host "[OK] Tim thay Visual Studio instance: $vsInstanceId" -ForegroundColor Green
    Write-Host "  Duong dan: $vsInstallationPath" -ForegroundColor Gray
    Write-Host ""
    
    Write-Host "Dang chuan bi cai dat components..." -ForegroundColor Cyan
    
    # Cac workload va components can thiet
    $workloads = @(
        "Microsoft.VisualStudio.Workload.NativeDesktop"
    )
    
    # Components se duoc cai tu dong thong qua workload va --includeRecommended
    $components = @(
        "Microsoft.VisualStudio.Component.CMake.Tools",
        "Microsoft.VisualStudio.Component.Windows10SDK.20348"
    )
    
    Write-Host "Cac components se duoc cai dat:" -ForegroundColor Yellow
    Write-Host "  - Workload: Desktop development with C++" -ForegroundColor White
    Write-Host "  - MSVC C++ build tools (x64/x86)" -ForegroundColor White
    Write-Host "  - C++ CMake tools for Windows" -ForegroundColor White
    Write-Host "  - Windows 10 SDK" -ForegroundColor White
    Write-Host ""
    
    if ($Quiet) {
        Write-Host "Dang cai dat trong che do quiet (yen lang)..." -ForegroundColor Cyan
        Write-Host "Qua trinh nay co the mat 10-30 phut, vui long doi..." -ForegroundColor Yellow
        Write-Host ""
        
        # Xay dung danh sach arguments cho vs_installer
        $arguments = @(
            "modify"
            "--installPath"
            $vsInstallationPath
            "--quiet"
            "--wait"
            "--norestart"
            "--includeRecommended"
        )
        
        # Them workloads
        foreach ($workload in $workloads) {
            $arguments += "--add"
            $arguments += $workload
        }
        
        # Them components
        foreach ($component in $components) {
            $arguments += "--add"
            $arguments += $component
        }
        
        Write-Host "Dang chay Visual Studio Installer..." -ForegroundColor Cyan
        Write-Host "Command: $vsInstallerPath $($arguments -join ' ')" -ForegroundColor Gray
        Write-Host ""
        
        # Chay voi elevated privileges neu can
        $process = Start-Process -FilePath $vsInstallerPath -ArgumentList $arguments -Wait -PassThru -NoNewWindow
        
        if ($process.ExitCode -eq 0) {
            Write-Host ""
            Write-Host "[OK] Cai dat hoan tat!" -ForegroundColor Green
        } else {
            Write-Host ""
            Write-Host "[WARNING] Qua trinh cai dat ket thuc voi ma loi: $($process.ExitCode)" -ForegroundColor Yellow
            Write-Host "Vui long kiem tra lai hoac chay lai script khong co tham so -Quiet" -ForegroundColor Yellow
        }
    } else {
        Write-Host "Dang mo Visual Studio Installer..." -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Vui long lam theo cac buoc sau:" -ForegroundColor Yellow
        Write-Host "  1. Chon 'Modify' cho Visual Studio instance da tim thay" -ForegroundColor White
        Write-Host "  2. Chon workload 'Desktop development with C++'" -ForegroundColor White
        Write-Host "  3. Trong tab 'Individual components', dam bao chon:" -ForegroundColor White
        Write-Host "     - MSVC v142 - VS 2019 C++ x64/x86 build tools (hoac v143/v144 cho VS 2022)" -ForegroundColor White
        Write-Host "     - C++ CMake tools for Windows" -ForegroundColor White
        Write-Host "     - Windows 10 SDK (10.0.19041.0 hoac moi hon)" -ForegroundColor White
        Write-Host "  4. Nhan 'Modify' va cho qua trinh cai dat hoan tat" -ForegroundColor White
        Write-Host ""
        
        $modifyArgs = @("modify", "--installPath", "`"$vsInstallationPath`"")
        Start-Process $vsInstallerPath -ArgumentList $modifyArgs
    }
} else {
    Write-Host "[WARNING] Khong tim thay Visual Studio instance nao da cai dat." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Dang mo Visual Studio Installer de cai dat moi..." -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Vui long:" -ForegroundColor Yellow
    Write-Host "  1. Chon 'Install' de cai dat Visual Studio moi" -ForegroundColor White
    Write-Host "  2. Chon workload 'Desktop development with C++'" -ForegroundColor White
    Write-Host "  3. Hoac cai dat 'Visual Studio Build Tools'" -ForegroundColor White
    Write-Host ""
    
    Start-Process $vsInstallerPath
}

Write-Host ""
Write-Host "=== Huong dan sau khi cai dat ===" -ForegroundColor Cyan
Write-Host "Sau khi cai dat xong, chay lenh sau de kiem tra:" -ForegroundColor Yellow
Write-Host "  flutter doctor" -ForegroundColor White
Write-Host ""
Write-Host "Tat ca cac muc phai co dau [OK] (checkmark) xanh." -ForegroundColor Gray

