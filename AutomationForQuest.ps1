
Param (
    [string] $region = "EU",
    [string] $orgId,
    [string] $IdProgect,
    [string] $csvPath
)

Start-Transcript -Path "C:\temp\quest_log.txt" -Append

Import-Module OdmApi

# 1. Connessione al servizio ODM
Write-Host -ForegroundColor Cyan
Connect-OdmService -Region $region -UseIntegratedWindowsAuth 



# 2. Selezione Organizzazione
# Inserisci l'ID che hai trovato con Get-OdmOrganization

Select-OdmOrganization -OrganizationId $orgId

# selezione progetto
# $IdProgect ="********************"
Select-OdmProject  -ProjectId $IdProgect

# # id collection pilot wave cut over
# $IdCollection ="******************"

# 3. Caricamento del Bulk dal CSV
# $csvPath = "C:\Users\MarwanRafik\OneDrive - AGIC\Desktop\exportTaskPilotCutOver1.csv"



if (Test-Path $csvPath) {
    $tasks = Import-Csv -Path $csvPath -Delimiter ";"
    Write-Host "Trovati $($tasks.Count) task da processare nel file CSV." -ForegroundColor Yellow


    foreach ($row in $tasks) {
        $id = $row.Id
        
    
        
        Write-Host "Avvio task in corso: $id..." -NoNewline
        try {
           
            Start-OdmTask -Task $id
            Write-Host " [COMPLETATO]" -ForegroundColor Green
        } catch {
            Write-Host " [FALLITO]" -ForegroundColor Red
            Write-Warning "Errore sul task $id : $($_.Exception.Message)"
        }
    }
} else {
    Write-Error "File CSV non trovato in $csvPath. Crea il file e riprova."
}

Write-Host "Procedura Bulk terminata. Puoi chiudere la finestra." -ForegroundColor White -BackgroundColor DarkGreen

Stop-Transcript


