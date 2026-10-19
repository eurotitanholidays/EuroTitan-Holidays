# EuroTitan Holidays - downloads photos + fonts so the site hosts them itself.
# Run from this folder:  powershell -ExecutionPolicy Bypass -File download-assets.ps1
$ErrorActionPreference = "Continue"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
New-Item -ItemType Directory -Force -Path images | Out-Null
New-Item -ItemType Directory -Force -Path fonts | Out-Null

$photos = @(
  @("1485871981521-5b1fd3805eee",1100),
  @("1488646953014-85cb44e25828",1100),
  @("1496588152823-86ff7695e68f",1100),
  @("1497373637916-e47a55e22d0a",1100),
  @("1502602898657-3e91760cbb34",700),
  @("1502602898657-3e91760cbb34",1100),
  @("1503177119275-0aa32b3a9368",1100),
  @("1511739001486-6bfe10ce785f",1100),
  @("1512453979798-5ea266f8880c",1100),
  @("1514282401047-d79a71a590e8",1100),
  @("1518684079-3c830dcef090",1100),
  @("1520175480921-4edfa2983e0f",1000),
  @("1526026697130-3f870884a6e3",480),
  @("1526026697130-3f870884a6e3",800),
  @("1526026697130-3f870884a6e3",1000),
  @("1526026697130-3f870884a6e3",1100),
  @("1527605158555-853f200063e9",1100),
  @("1527838832700-5059252407fa",1100),
  @("1531152369337-1d0b0b9ef20d",1100),
  @("1580502304784-8985b7eb7260",1100),
  @("1609082565521-31707c9f0c79",1100),
  @("1611582537127-514909c1167d",1000),
  @("1637514122357-abb455ced272",1100),
  @("1639616322896-357c8e5a449a",1100),
  @("1688680436936-0175962af721",1000),
  @("1699519324068-8cade0601b53",1100),
  @("1708651659018-b10655c83d30",1100),
  @("1742327648952-5babf1d04ae4",480),
  @("1742327648952-5babf1d04ae4",800),
  @("1742327648952-5babf1d04ae4",1100),
  @("1759310347558-d73a6af2d487",1100),
  @("1767342976245-b34c150bddf9",480),
  @("1767342976245-b34c150bddf9",800),
  @("1767342976245-b34c150bddf9",1100),
  @("1777541743077-de523b619fb3",1000)
)
foreach ($p in $photos) {
  $id = $p[0]; $w = $p[1]
  $out = "images/$id-$w.jpg"
  if (Test-Path $out) { continue }
  $url = "https://images.unsplash.com/photo-$id" + "?q=65&w=$w&auto=format&fit=crop"
  try { Invoke-WebRequest -Uri $url -OutFile $out -UseBasicParsing; Write-Host "OK  $out" }
  catch { Write-Host "FAIL $out" }
}

# ---- fonts (latin subset) ----
$ua = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0 Safari/537.36"
$cssUrl = "https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,500;0,600;0,700;1,500&family=Inter:wght@400;500;600;700&display=swap"
$css = (Invoke-WebRequest -Uri $cssUrl -Headers @{"User-Agent"=$ua} -UseBasicParsing).Content
$blocks = [regex]::Matches($css, "/\* (?<sub>[a-z0-9-]+) \*/\s*@font-face\s*\{(?<body>[^}]*)\}")
$final = ""
foreach ($b in $blocks) {
  if ($b.Groups["sub"].Value -ne "latin") { continue }
  $body = $b.Groups["body"].Value
  $fam = ([regex]::Match($body, "font-family:\s*'([^']+)'")).Groups[1].Value
  $sty = ([regex]::Match($body, "font-style:\s*(\w+)")).Groups[1].Value
  $wt  = ([regex]::Match($body, "font-weight:\s*(\d+)")).Groups[1].Value
  $src = ([regex]::Match($body, "url\((https[^)]+)\)")).Groups[1].Value
  $ur  = ([regex]::Match($body, "unicode-range:\s*([^;]+);")).Groups[1].Value
  $name = ($fam.ToLower() -replace " .*","") + "-" + $sty + "-" + $wt + ".woff2"
  Invoke-WebRequest -Uri $src -OutFile "fonts/$name" -UseBasicParsing
  Write-Host "OK  fonts/$name"
  $final += "@font-face{font-family:'$fam';font-style:$sty;font-weight:$wt;font-display:swap;src:url($name) format('woff2');unicode-range:$ur}`n"
}
if ($final.Length -gt 0) { Set-Content -Path fonts/fonts.css -Value $final -Encoding UTF8 }
Write-Host ""
Write-Host "Done. Upload the new 'images' and 'fonts' folders to your GitHub repo root (next to index.html)."
