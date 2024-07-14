<#
.SYNOPSIS
Faz o download(opcional), extrai e "instala" o GHDL (v0.37).

.DESCRIPTION
Faz o download(opcional) e extrai e o GHDL (v0.37).
Adiciona o executável ao PATH do sistema.

.PARAMETER destino
Caminho para descompactação do GHDL.

.PARAMETER zip
Caminho do arquivo .zip contendo o GHDL. Ignorado se usado com a flag -download.

.Parameter download
Fazer download do GHDL?

.EXAMPLE
PS> .\instalarGHDL.ps1 -zip ".\ghdl-0.37-mingw32-mcode.zip"

.EXAMPLE
PS> .\instalarGHDL.ps1 -destino "C:\Program Files"

.EXAMPLE
PS> .\instalarGHDL.ps1 -download -destino "C:\Program Files"

#>

# Parâmetros de CL.
param (
    [string]$destino  = ".\",
    [string]$zip      = ".\ghdl-0.37-mingw32-mcode.zip",
    [switch]$download = $false
)

# Download do arquivo.
if($download) {
    Write-Output "Baixando arquivo (~5MB)..."
    Invoke-WebRequest https://github.com/ghdl/ghdl/releases/download/v0.37/ghdl-0.37-mingw32-mcode.zip -O ghdl-0.37-mingw32-mcode.zip
    $zip = ".\ghdl-0.37-mingw32-mcode.zip"
    Write-Output "Pronto."
}

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
$env:Path = $env:Path,"$fullpath\GHDL\0.37-mingw32-mcode\bin" -join ";"
[System.Environment]::SetEnvironmentVariable('Path', $env:Path, [System.EnvironmentVariableTarget]::Machine)
Write-Output "Pronto."