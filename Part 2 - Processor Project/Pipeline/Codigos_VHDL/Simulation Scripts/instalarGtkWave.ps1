<#
.SYNOPSIS
Extrai e "instala" o GtkWave.

.DESCRIPTION
Extrai e o GtkWave (version 3.3.100).
Adiciona o executável ao PATH do sistema.

.PARAMETER destino
Caminho para descompactação do GtkWave.

.PARAMETER zip
Caminho do arquivo .zip contendo o GtkWave. Ignorado se usado com a flag -download.

.EXAMPLE
PS> .\instalarGHDL.ps1 -zip ".\gtkwave-3.3.100-bin-win64.zip"

.EXAMPLE
PS> .\instalarGHDL.ps1 -destino "C:\programs"

#>

# Parâmetros de CL.
param (
    [string]$destino  = ".\",
    [string]$zip      = ".\gtkwave-3.3.100-bin-win64.zip"
)

# Descompactar.
if (Test-Path -LiteralPath $zip) {
    Write-Output "Descompactando arquivo .zip..."
    Expand-Archive -LiteralPath $zip -DestinationPath $destino -Force
    Write-Output "Pronto."
} else {
    Write-Output "Arquivo '$zip' nao encontrado! Abortando script."
    exit
}

#Adicionar ao PATH do sistema."
Write-Output "Adicionando caminho do arquivo ao Path do sistema..."
$fullpath = (Get-Item -Path "$destino").FullName
$env:Path = $env:Path,"$fullpath\gtkwave64\bin" -join ";"
[System.Environment]::SetEnvironmentVariable('Path', $env:Path, [System.EnvironmentVariableTarget]::Machine)
Write-Output "Pronto."