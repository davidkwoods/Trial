# Inspired by Mark Embling
# http://www.markembling.info/view/my-ideal-powershell-prompt-with-git-integration

$global:GitPromptSettings = New-Object PSObject -Property @{
    DefaultForegroundColor    = $Host.UI.RawUI.ForegroundColor

    BeforeText                = ' ['
    BeforeForegroundColor     = [ConsoleColor]::Yellow
    BeforeBackgroundColor     = $Host.UI.RawUI.BackgroundColor    
    DelimText                 = ' |'
    DelimForegroundColor      = [ConsoleColor]::Yellow
    DelimBackgroundColor      = $Host.UI.RawUI.BackgroundColor
    
    AfterText                 = ']'
    AfterForegroundColor      = [ConsoleColor]::Yellow
    AfterBackgroundColor      = $Host.UI.RawUI.BackgroundColor
    
    Branch1ForegroundColor    = [ConsoleColor]::Cyan
    Branch1BackgroundColor    = $Host.UI.RawUI.BackgroundColor
    Branch2ForegroundColor    = [ConsoleColor]::Red
    Branch2BackgroundColor    = $Host.UI.RawUI.BackgroundColor
    
    BeforeIndexText           = ""
    BeforeIndexForegroundColor= [ConsoleColor]::Green
    BeforeIndexBackgroundColor= $Host.UI.RawUI.BackgroundColor
    
    IndexForegroundColor      = [ConsoleColor]::Green
    IndexBackgroundColor      = $Host.UI.RawUI.BackgroundColor
    
    WorkingForegroundColor    = [ConsoleColor]::Yellow
    WorkingBackgroundColor    = $Host.UI.RawUI.BackgroundColor
    
    UntrackedText             = ' !'
    UntrackedForegroundColor  = [ConsoleColor]::Yellow
    UntrackedBackgroundColor  = $Host.UI.RawUI.BackgroundColor
    
    ShowStatusWhenZero        = $true
    
    AutoRefreshIndex          = $true

    EnablePromptStatus        = $true
    EnableFileStatus          = $true

    Debug                     = $false
}

function Write-GitStatus($status) {
    $s = $global:GitPromptSettings
    if ($status -and $s) {
        $currentBranch = $status.Branch
        
        Write-Host $s.BeforeText -NoNewline -BackgroundColor $s.BeforeBackgroundColor -ForegroundColor $s.BeforeForegroundColor
        if ($status.AheadBy -eq 0) {
            # We are not ahead of origin
            Write-Host $currentBranch -NoNewline -BackgroundColor $s.Branch1BackgroundColor -ForegroundColor $s.Branch1ForegroundColor
        } else {
            # We are ahead of origin
            Write-Host $currentBranch -NoNewline -BackgroundColor $s.Branch2BackgroundColor -ForegroundColor $s.Branch2ForegroundColor
        }
        
        if($s.EnableFileStatus -and $status.HasIndex) {
            write-host $s.BeforeIndexText -NoNewLine -BackgroundColor $s.BeforeIndexBackgroundColor -ForegroundColor $s.BeforeIndexForegroundColor
            
            if($s.ShowStatusWhenZero -or $status.Index.Added) {
              Write-Host " +$($status.Index.Added.Count)" -NoNewline -BackgroundColor $s.IndexBackgroundColor -ForegroundColor $s.IndexForegroundColor
            }
            if($s.ShowStatusWhenZero -or $status.Index.Modified) {
              Write-Host " ~$($status.Index.Modified.Count)" -NoNewline -BackgroundColor $s.IndexBackgroundColor -ForegroundColor $s.IndexForegroundColor
            }
            if($s.ShowStatusWhenZero -or $status.Index.Deleted) {
              Write-Host " -$($status.Index.Deleted.Count)" -NoNewline -BackgroundColor $s.IndexBackgroundColor -ForegroundColor $s.IndexForegroundColor
            }

            if ($status.Index.Unmerged) {
                Write-Host " !$($status.Index.Unmerged.Count)" -NoNewline -BackgroundColor $s.IndexBackgroundColor -ForegroundColor $s.IndexForegroundColor
            }

            if($status.HasWorking) {
                Write-Host $s.DelimText -NoNewline -BackgroundColor $s.DelimBackgroundColor -ForegroundColor $s.DelimForegroundColor
            }
        }
        
        if($s.EnableFileStatus -and $status.HasWorking) {
            if($s.ShowStatusWhenZero -or $status.Working.Added) {
              Write-Host " +$($status.Working.Added.Count)" -NoNewline -BackgroundColor $s.WorkingBackgroundColor -ForegroundColor $s.WorkingForegroundColor
            }
            if($s.ShowStatusWhenZero -or $status.Working.Modified) {
              Write-Host " ~$($status.Working.Modified.Count)" -NoNewline -BackgroundColor $s.WorkingBackgroundColor -ForegroundColor $s.WorkingForegroundColor
            }
            if($s.ShowStatusWhenZero -or $status.Working.Deleted) {
              Write-Host " -$($status.Working.Deleted.Count)" -NoNewline -BackgroundColor $s.WorkingBackgroundColor -ForegroundColor $s.WorkingForegroundColor
            }

            if ($status.Working.Unmerged) {
                Write-Host " !$($status.Working.Unmerged.Count)" -NoNewline -BackgroundColor $s.WorkingBackgroundColor -ForegroundColor $s.WorkingForegroundColor
            }
        }
        
        if ($status.HasUntracked) {
            Write-Host $s.UntrackedText -NoNewline -BackgroundColor $s.UntrackedBackgroundColor -ForegroundColor $s.UntrackedForegroundColor
        }
        
        Write-Host $s.AfterText -NoNewline -BackgroundColor $s.AfterBackgroundColor -ForegroundColor $s.AfterForegroundColor
    }
}
