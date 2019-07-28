$directoryToChoose = "C:\Program Files\Java"

function switchJavaInteractively
{
    $javaHomeDirectories = getJavaHomeDirectories
    $newJavaHome = getUserChoiceFor($javaHomeDirectories)
    setJavaHomeTo($newJavaHome)

    for ($i = 0; $i -lt $javaHomeDirectories.Count; $i++) {
        $javaHomeDirectory=$javaHomeDirectories[$i]
        $javaBin=$javaHomeDirectory+"\bin"
        removeFromEnvironmentPath($javaBin)
        removeFromEnvironmentPath($javaHomeDirectory)
    }
    addJavaHomeToPath
}

function removeFromEnvironmentPath{
    param([string]$pathToRemove = "")
    $env:Path = $env:Path.Replace($pathToRemove,"")
    removeDoubleSemicolonsInPath
}

function setJavaHomeTo
{
    param([string]$newJavaHome)
    $env:JAVA_HOME = $newJavaHome
}

function addJavaHomeToPath
{
    $env:Path = $env:JAVA_HOME + "\bin;" + $env:Path
}

function getUserChoiceFor
{
    param([Object[]]$paths)

    Write-Host "Choose your JDK"
    for ($i = 0; $i -lt $paths.Count; $i++) {
        $installDir = $paths[$i]

        Write-Host "[$i]" "-" $installDir
    }

    $userInput = Read-Host "Input: "
    #todo marmer read: https://stackoverflow.com/questions/50595251/adding-java-home-to-system-variable-path-via-powershell
    #todo marmer handle invalid input
    return $paths[$userInput]
}
function getJavaHomeDirectories
{
    return (ls $directoryToChoose).FullName
}

function removeDoubleSemicolonsInPath
{
    $env:Path = $env:Path.Replace(";;", ";")
}

removeDoubleSemicolonsInPath
switchJavaInteractively
