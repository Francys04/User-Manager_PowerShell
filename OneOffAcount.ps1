# Name 
# Username 
# GiveName 
# Surname 
# Description
# Title 

# Create function for this var
function New-OneOffADUser{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [String]$FirstName,
        [Parameter(Mandatory)]
        [String]$LastName,
        [Parameter(Mandatory)]
        [string]$Username,
        [Parameter(Mandatory)]
        [string]$Reason,
        [Parameter(Mandatory)]
        [string]$Server,
        [Parameter()]
        [datetime]$ExpirationDate,
        [Parameter()]
        [int]$PasswordLength=15
    )
    try{
        #show date if it's correct
        if($ExpirationDate){
            $Date=Get-Date -Date $ExpirationDate
        }
        # generate a passw
        #give a list 0..9 of data and generate random password of passwordlength parameter input
        $PlainTextPassword= -join(@('0'..'9';'A'..'Z';'a'..'z';'!';'@';'#';'$';',';'%';'*';'&') | Get-Random -Count $PasswordLength)
        $Password = ConvertTo-SecureString -String $PlainTextPassword -AsPlainText -Force

        #create a hash table of all different proprities for AD users
        $ADUserParams=@{
            Name=$Username
            GiveName=$FirstName
            SurName=$LastName
            SumAccountName=$Username
            UserPrincipalName="$Username@morohai.co"
            Title=$Reason
            Enabled=$true
            AccountPassword=$Password
            Server=$Server
        }
        if($Date){
            New-User @ADUserParams -ExpirationDate $Date
        }else{
            New-OneOffADUser @ADUserParams
        }
        Write-Output "User created for $FirstName $LastName with the username: $Username and password: $PlainTextPassword"
        #check the parameters of ADuser
        # Write-Output $ADUserParams

#give the date output
        # Write-Output $Date
#show error of the code
    }catch{
        Write-Error $_.Exception.Message
    }
}

#check the function -> if put day 31 of february, terminal give an error, like that check the DateTime (Write-Error $_.Exception.Message)
New-OneOffADUser -FirstName "Alex" -LastName "Morohai" -Username "francys04" -Reason "test this" -Server "server1" -ExpirationDate "2022-7-31"