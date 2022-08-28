# Generate some dumb passwords from a keyword
function Gen-Dict {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, Position=0, HelpMessage="Enter keyword..")]  
        [ValidateNotNullOrEmpty()]
        [string]$keyword
    )

    $norm = $keyword
    $upper = $keyword.ToUpper()
    $lower = $keyword.ToLower()
    $leet = $keyword.Replace('a', '@').Replace('e', '3').Replace('i', '!').Replace('o', '0').Replace('t', '+')
    $leet2 = $keyword.Replace('a', '@').Replace('e', '3').Replace('i', '1').Replace('o', '0').Replace('t', '+').Replace('E', '3').Replace('I', '1').Replace('A', '@').Replace('O', '0').Replace('T', '+').ToUpper()
    $leet3 = $keyword.Replace('a', '@').Replace('e', '3').Replace('i', '1').Replace('o', '0').Replace('t', '+').Replace('E', '3').Replace('I', '1').Replace('A', '@').Replace('O', '0').Replace('T', '+').ToLower()
    $leet4 = $keyword.Replace('a', '@').Replace('e', '3').Replace('i', '1').Replace('o', '0').Replace('t', '+').Replace('E', '3').Replace('I', '1').Replace('A', '@').Replace('O', '0').Replace('T', '+')

    # create a numbered dictionary for each permutation of the word
    # Make this a function we can pass a rnage to, but default to 1-100
    $normlist = for ($i = 1; $i -le 100; $i++) { $norm+$i }
    $upperlist = for ($i = 1; $i -le 100; $i++) { $upper+$i }
    $lowerlist = for ($i = 1; $i -le 100; $i++) { $lower+$i }
    $leetlist = for ($i = 1; $i -le 100; $i++) { $leet+$i }
    $leetlist2 = for ($i = 1; $i -le 100; $i++) { $leet2+$i }
    $leetlist3 = for ($i = 1; $i -le 100; $i++) { $leet3+$i }
    $leetlist4 = for ($i = 1; $i -le 100; $i++) { $leet4+$i }


    # create permutation with years
    # Make this a function we can pass a validated range of years as a $min $max 
    $normyear = for ($i = 1900; $i -le 2025; $i++) { $norm+$i }
    $upperyear = for ($i = 1900; $i -le 2025; $i++) { $upper+$i }
    $loweryear = for ($i = 1900; $i -le 2025; $i++) { $lower+$i }
    $leetyear = for ($i = 1900; $i -le 2025; $i++) { $leet+$i }
    $leetyear2 = for ($i = 1900; $i -le 2025; $i++) { $leet2+$i }
    $leetyear3 = for ($i = 1900; $i -le 2025; $i++) { $leet3+$i }
    $leetyear4 = for ($i = 1900; $i -le 2025; $i++) { $leet3+$i }

    # combine lists
    $combo = $normlist+$upperlist+$lowerlist+$leetlist+$leetlist2+$leetlist3+$normyear+$upperyear+$loweryear+$leetyear+$leetyear2+$leetyear3
    $combo > passlist.txt
}

Gen-Dict