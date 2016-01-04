<#
.Synopsis
   A simple Pomodoro clock with PowerShell
.DESCRIPTION
   The script will act as a Pomodoro clock for those who use the time management technique. The default is 25 minute Pomorodo work time followed by 5 minutes break.
   PowerShell progress bar will display the current status. Also you can use -EnableAudio to have it beep at the end of 25 minutes.
   You can specify the number of Pomodomos as well.
.EXAMPLE
   Start-Podomoro -PomodoroCount 3 -Verbose
.EXAMPLE
   Start-Podomoro -PomodoroCount 3 -EnableAudio -Verbose
.NOTES
   Time: 2016-Jan-04
   Created by Lawrence Hwang
   Twitter: CPoweredLion
#>
function Start-Pomodoro {

    [cmdletBinding()]

    Param(
        
        [Parameter(Mandatory=$false,
                   HelpMessage ="Pomodoro Count",
                   Position=0)]    
        [int]$PomodoroCount = 1,

        [Parameter(Mandatory=$false,
                   HelpMessage ="Time (minutes) in each Pomodoro",
                   Position=1)]
        [int]$OnePomodoroTime =25,

        [Parameter(Mandatory=$false,
                   HelpMessage ="Break time (minutes) in each Pomodoro")]
        [int]$BreakTime =5,
        
        [Parameter(Mandatory=$false,
                   HelpMessage ="Second in every minute. Used for testing purpose.")]
        [int] $second =60,

        [Parameter(Mandatory=$false,
                   HelpMessage ="Enable the beep")]  
        [switch] $EnableAudio,

        [Parameter(Mandatory=$false,
                   HelpMessage ="Clear the screen at the beginning")]  
        [switch] $cls
    
    )
    
    Begin {

        if ($cls){
            clear-host
        }

        Write-Verbose -Message "Pomodoro Clock started on $((get-date).toshorttimestring())"
    
    }

    Process{
        
        $p = 0

        Do{
            For ($i=0 ; $i -lt $OnePomodoroTime ; $i ++){
            
                Write-Progress -id 0 -Activity 'Pomodoro Clock' -PercentComplete ($i/$OnePomodoroTime*100) -Status 'Minutes'

                For ($j=1 ; $j -lt $second ; $j ++){                 
            
                        Write-Progress -id 1 -Activity 'Tick Tock' -PercentComplete ($j/$second*100) -Status 'Seconds'
                        Start-Sleep -Seconds 1
            
                }
            }

            if ($EnableAudio){
                    
                    #Beep
                    1..3 | ForEach-Object { [System.Media.SystemSounds]::beep.Play() ; sleep -m 470}
                    
            }
             
            #Provide visual feedback with pop-up windows. The windows will be in focus.
            [void] [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualBasic")
            [Microsoft.VisualBasic.Interaction]::MsgBox("Good Job! $($p+1) Pomodoro ($(($p+1)*$OnePomodoroTime) min) of $PomodoroCount Pomodoro completed. Press OK to start 5 min break.", "OKOnly,SystemModal,Information", "Pomodoro Clock") | out-null

            For ($b=1 ; $b -lt $BreakTime*$second ; $b ++){                 
            
                Write-Progress -id 2 -Activity '5 Min Break' -PercentComplete ($b/($BreakTime*$second)*100) -Status "Don`'t look at me!"
                Start-Sleep -Seconds 1
                    
            }

            if ($EnableAudio){

                #Beep
                1..3 | ForEach-Object { [System.Media.SystemSounds]::beep.Play() ; sleep -m 470}
                    
            }
            
            #Provide visual feedback with pop-up windows. The windows will be in focus.
            [Microsoft.VisualBasic.Interaction]::MsgBox("Break done for $($p+1) of $PomodoroCount Pomodoro.Press OK to continue.", "OKOnly,SystemModal,Information", "Pomodoro Clock") | out-null

            $p = $p + 1

        } While ($p -lt $PomodoroCount )    
    }

    End{
        Write-Verbose -Message "Completed $PomodoroCount Pomodoro."
        Write-Verbose -Message "Pomodoro Clock ended on $((get-date).toshorttimestring())"
    }
}

Export-ModuleMember -Function Start-Pomodoro
