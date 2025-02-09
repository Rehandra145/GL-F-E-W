# Komgraf Project Manager PowerShell Version
$ESC = [char]27
$Host.UI.RawUI.WindowTitle = "Komgraf Project Manager"

# Warna konstan
$RED = "$ESC[91m"
$GREEN = "$ESC[92m"
$YELLOW = "$ESC[93m"
$CYAN = "$ESC[96m"
$BLUE = "$ESC[94m"
$MAGENTA = "$ESC[95m"
$WHITE = "$ESC[97m"
$RESET = "$ESC[0m"

function Show-Menu {
    Clear-Host
    Write-Host ""
    Write-Host "$CYAN============================================$RESET"
    Write-Host "     $BLUE=== KOMGRAF PROJECT MANAGEMENT ===$RESET"
    Write-Host "$WHITE               by: HANDERA                  $RESET"   
    Write-Host "$CYAN============================================$RESET"
    Write-Host ""
    Write-Host "$WHITE 1. Create New Project$RESET"
    Write-Host "$WHITE 2. Open Existing Project$RESET"
    Write-Host "$WHITE 3. Delete Existing Project$RESET"
    Write-Host "$WHITE 4. Exit Program$RESET"
    Write-Host ""
    Write-Host "$CYAN============================================$RESET"
    Write-Host ""
}

function Check-KomgrafDir {
    if (-not (Test-Path "C:\Komgraf")) {
        Write-Host ""
        Write-Host "$RED[ERROR]$RESET Directory C:\Komgraf not found!"
        Write-Host "$YELLOW[INFO]$RESET Please create directory first"
        Write-Host ""
        pause
        exit
    }
    Set-Location "C:\Komgraf"
}

function Create-Project {
    Clear-Host
    Write-Host ""
    Write-Host "$CYAN============================================$RESET"
    Write-Host "        $BLUE=== CREATE NEW PROJECT ===$RESET"        
    Write-Host "$CYAN============================================$RESET"
    Write-Host ""

    if (-not (Test-Path "Template")) {
        Write-Host "$RED[ERROR]$RESET Template directory not found!"
        Start-Sleep -Seconds 2
        return
    }

    do {
        $pname = Read-Host "$YELLOW Enter project name (press '0' to back):$RESET"
        if ($pname -eq "0") { return }
        if ([string]::IsNullOrEmpty($pname)) {
            Write-Host "$RED[ERROR]$RESET Project name cannot be empty!"
            continue
        }
        if (Test-Path $pname) {
            Write-Host "$RED[ERROR]$RESET Project '$pname' already exists!"
            continue
        }
        break
    } while ($true)

    try {
        New-Item -Path $pname -ItemType Directory | Out-Null
        Copy-Item -Path "Template\*" -Destination $pname -Recurse -Force
        Write-Host ""
        Write-Host "$CYAN============================================$RESET"
        Write-Host "$GREEN[SUCCESS]$RESET Project created: $CYAN$pname$RESET"
        Write-Host "$YELLOW Location:$RESET $(Get-Location)\$pname"
        Write-Host "$CYAN============================================$RESET"
    }
    catch {
        Write-Host "$RED[ERROR]$RESET Failed to create project directory!"
    }
    
    Start-Sleep -Seconds 2
}

function Open-Project {
    Clear-Host
    Write-Host ""
    Write-Host "$CYAN============================================$RESET"
    Write-Host "      $BLUE=== OPEN EXISTING PROJECT ===$RESET"      
    Write-Host "$CYAN============================================$RESET"
    Write-Host ""

$projects = Get-ChildItem -Directory | Where-Object { $_.Name -ne "Template" }

    if (-not $projects) {
        Write-Host "$YELLOW[INFO]$RESET No projects found"
        Start-Sleep -Seconds 2
        return
    }

    $index = 1
    foreach ($project in $projects) {
        Write-Host "$CYAN$index.$RESET $($project.Name)"
        $index++
    }

    Write-Host ""
    Write-Host "$CYAN============================================$RESET"
    Write-Host ""

    do {
        $pchoice = Read-Host "$YELLOW Enter project number (press '0' to back):$RESET"
        if ($pchoice -eq "0") { return }
        if (-not ($pchoice -match '^\d+$')) {
            Write-Host "$RED[ERROR]$RESET Please enter a valid number!"
            continue
        }
        if ([int]$pchoice -lt 1 -or [int]$pchoice -gt $projects.Count) {
            Write-Host "$RED[ERROR]$RESET Invalid project number!"
            continue
        }
        break
    } while ($true)

    $selected = $projects[[int]$pchoice - 1]
    Write-Host ""
    Write-Host "$CYAN============================================$RESET"
    Write-Host "$YELLOW[STATUS]$RESET Opening project $CYAN$($selected.Name)$RESET..."
    Write-Host "$CYAN============================================$RESET"

    try {
        Set-Location $selected.FullName
        Write-Host "$YELLOW[STATUS]$RESET Compiling project..."
        & g++ main.cpp -o bin/main.exe -Iinclude -Llib -lglfw3 -lglew32 -lopengl32 -lgdi32 -lglu32 -lfreeglut
        
        if (-not (Test-Path "bin\main.exe")) {
            throw "Compilation failed"
        }
        
        Write-Host "$GREEN[SUCCESS]$RESET Project compiled successfully!"
        Start-Process code "." -NoNewWindow
        Start-Process "bin\main.exe" -NoNewWindow
        Start-Sleep -Seconds 2
        Set-Location "C:\Komgraf"
    }
    catch {
        Write-Host "$RED[ERROR]$RESET Failed to compile! Please check main.cpp."
        Start-Sleep -Seconds 3
    }
}

function Delete-Project {
    Clear-Host
    Write-Host ""
    Write-Host "$CYAN============================================$RESET"
    Write-Host "      $BLUE=== DELETE EXISTING PROJECT ===$RESET"      
    Write-Host "$CYAN============================================$RESET"
    Write-Host ""
    Set-Location "C:\Komgraf"
    $projects = Get-ChildItem -Directory | Where-Object { $_.Name -ne "Template" }
    if (-not $projects) {
        Write-Host "$YELLOW[INFO]$RESET No projects found"
        Start-Sleep -Seconds 2
        return
    }

    $index = 1
    foreach ($project in $projects) {
        Write-Host "$CYAN$index.$RESET $($project.Name)"
        $index++
    }

    Write-Host ""
    Write-Host "$CYAN============================================$RESET"
    Write-Host ""

    do {
        $pchoice = Read-Host "$YELLOW Enter project number to delete (press '0' to back):$RESET"
        if ($pchoice -eq "0") { return }
        if (-not ($pchoice -match '^\d+$')) {
            Write-Host "$RED[ERROR]$RESET Please enter a valid number!"
            continue
        }
        if ([int]$pchoice -lt 1 -or [int]$pchoice -gt $projects.Count) {
            Write-Host "$RED[ERROR]$RESET Invalid project number!"
            continue
        }
        break
    } while ($true)

    $selected = $projects[[int]$pchoice - 1]
    
    # Konfirmasi
    do {
        $confirm = Read-Host "$YELLOW Are you sure you want to delete '$($selected.Name)'? (Y/N)$RESET"
        if ($confirm -notmatch '^[ynYN]$') {
            Write-Host "$RED[ERROR]$RESET Please enter Y or N!"
            continue
        }
        break
    } while ($true)

    if ($confirm -in @('Y','y')) {
        try {
            Remove-Item -Path $selected.FullName -Recurse -Force
            Write-Host ""
            Write-Host "$GREEN[SUCCESS]$RESET Project '$CYAN$($selected.Name)$RESET' has been deleted!"
            Start-Sleep -Seconds 2
        }
        catch {
            Write-Host "$RED[ERROR]$RESET Failed to delete project!"
            Start-Sleep -Seconds 2
        }
    }
    else {
        Write-Host "$YELLOW[INFO]$RESET Deletion cancelled"
        Start-Sleep -Seconds 1
    }
}

# Main program
Check-KomgrafDir

while ($true) {
    Show-Menu
    $choice = Read-Host "$YELLOW Enter your choice [1-4]:$RESET"
    
    switch ($choice) {
        "1" { Create-Project }
        "2" { Open-Project }
        "3" { Delete-Project }
        "4" { exit }
        default {
            Write-Host ""
            Write-Host "$RED[ERROR]$RESET Invalid selection! Please try again"
            Start-Sleep -Seconds 2
        }
    }
}