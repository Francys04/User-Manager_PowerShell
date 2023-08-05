#This section defines the New-UserName function with the specified 
#parameters using the [CmdletBinding()] attribute and the Param block.
function New-UserName{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [string]$FirstName,
        [Parameter(Mandatory)]
        [string]$LastName,
        [Parameter(Mandatory)]
        [string]$Server
    )
#A try block begins. A regular expression pattern $Pattern is created 
#to match spaces, hyphens, and apostrophes. $Index is initialized to 1.
    try{
        [RegEx]$Pattern="\s|-|'"
        $Index=1
#A do...while loop is used to generate a unique username based on the given $FirstName and $LastName. 
#The loop iterates as long as there is a user with the same SamAccountName and the generated username does 
#not match the initial combination of first and last names.
        do{
            $Username="$LastName$($FirstName.Substring(0,$Index))" -replace $Pattern,""
            $Index++
        }while((Get-ADUser -Filter "SamAccountName -like '$Username'" -Server $Server) -and ($Username -notlike "$LastName$FirstName"))
#Checks if a user with the same SamAccountName already exists. If yes, it throws an error indicating that no usernames are available. 
#Otherwise, it returns the generated unique username.
        if((Get-ADUser -Filter "SamAccountName -like '$Username'" -Server $Server)){
            throw "No usernames available for this account"
        }else{
            return $Username
        }
    }catch{
        Write-Error $_.Exception.Message
        throw $_.Exception.Message
    }#The catch block handles any exceptions that may occur within the function. It writes an error message and rethrows the exception.
}
#New-OneOffADUser function with the specified parameters 
#and default values. The function uses [CmdletBinding()] and Param to set up the parameter block.
function New-OneOffADUser{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [string]$FirstName,
        [Parameter(Mandatory)]
        [string]$LastName,
        [Parameter()]
        [string]$Username,
        [Parameter(Mandatory)]
        [string]$Reason,
        [Parameter(Mandatory)]
        [string]$Server,
        [Parameter()]
        [datetime]$ExpirationDate,
        [Parameter()]
        [int]$PasswordLength=15,
        [Parameter()]
        $ChangePasswordAtNextLogon=$true
    )
#A try block begins. It checks if a username is provided. If not, it calls the New-UserName 
#function to generate a unique username based on the given first name, last name, and server.
    try{
        if(-not $Username){
            $Username=New-UserName -FirstName $FirstName -LastName $LastName -Server $Server
        }
#Checks if an expiration date is provided. If yes, it converts the provided date into a DateTime object using Get-Date.
        if($ExpirationDate){
            $Date=Get-Date -Date $ExpirationDate
        }
#Generates a random password composed of alphanumeric and special characters. It converts the plain text password to a secure string.
        $PlainTextPassword= -Join (@('0'..'9';'A'..'Z';'a'..'z';'!';'@';'#';'$','%','&') | Get-Random -Count $PasswordLength)
        $Password=ConvertTo-SecureString -String $PlainTextPassword -AsPlainText -Force
#Create a hash table $ADUserParams with properties to be used when creating the Active Directory user.
        $ADUserParams=@{
            Name=$Username
            GivenName=$FirstName
            SurName=$LastName
            SamAccountName=$Username
            UserPrincipalName="$Username@jacked.ca"
            Description=$Reason
            Title=$Reason
            Enabled=$true
            AccountPassword=$Password
            Server=$Server
            ChangePasswordAtLogon=$ChangePasswordAtNextLogon
        }
#Checks if an expiration date is provided. If yes, it uses New-User (assuming this is a function you have elsewhere) to create the user 
#account with the specified expiration date. If not, it calls the New-OneOffADUser function recursively.
        if($Date){
            New-ADUser @ADUserParams -AccountExpirationDate $Date
        }else{
            New-ADUser @ADUserParams
        }
#Outputs a message indicating the successful creation of the user, including the user's name, username, and generated password.
        Write-Output "User created for $FirstName $LastName with the username : $Username and password : $PlainTextPassword"

    }catch{
        Write-Error $_.Exception.Message
    }
}
# The New-UserName function generates a unique username based on first and last names. The New-OneOffADUser function 
#creates an Active Directory user account with various options, including generating a random password and setting account properties.
New-OneOffADUser -FirstName "Test" -LastName "Test" -Username 'TestUser1' -Reason "YouTube" -Server "jacked.ca" -ExpirationDate "2022-4-30" -PasswordLength 15