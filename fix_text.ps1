$file = "9345488724234\index.html"
$content = [System.IO.File]::ReadAllText($file, [System.Text.Encoding]::UTF8)

# The replacements dictionary
$replacements = @{
    'InformaÃ§Ãµes' = 'Informações'
    'preÃ§os' = 'preços'
    'visÃ­veis' = 'visíveis'
    'alcoÃ³licas' = 'alcoólicas'
    'moderaÃ§Ã£o' = 'moderação'
    'regiÃ£o' = 'região'
    'condiÃ§Ãµes' = 'condições'
    'cartÃ£o' = 'cartão'
    'crÃ©dito' = 'crédito'
    'polÃ­ticas' = 'políticas'
    'disponÃ­veis' = 'disponíveis'
    'PÃ¡gina' = 'Página'
    'transparÃªncia' = 'transparência'
    'Â©' = '©'
    'â€”' = '—'
    'â†’' = '→'
    'Â·' = '·'
}

$modified = $false
foreach ($key in $replacements.Keys) {
    if ($content.Contains($key)) {
        $content = $content.Replace($key, $replacements[$key])
        $modified = $true
    }
}

if ($modified) {
    [System.IO.File]::WriteAllText($file, $content, [System.Text.Encoding]::UTF8)
    Write-Output "index.html FIXED!"
} else {
    Write-Output "No replacements made in index.html"
}
