
## PowerShell Active Directory User Management-Creation Script
- This PowerShell script provides functions to create one-off Active Directory user accounts and generate unique usernames. It simplifies the process of generating usernames, setting passwords, and creating user accounts in an Active Directory environment.
- Next script provides a function, New-OneOffADUser, for creating user accounts in an Active Directory environment with customizable options.
## Description
- This function creates a new Active Directory user account with specified parameters, such as the user's name, username, expiration date, and more. It generates a secure random password and handles the account creation process.
- Also generates a unique username based on the user's first name and last name. It ensures that the generated username does not clash with existing usernames in the Active Directory.

## Parameters and Function of User Creation
### Parameters
- FirstName: The first name of the user. (Mandatory)
- LastName: The last name of the user. (Mandatory)
- Username: The desired username for the user. (Mandatory)
- Reason: A description or reason for creating the user account. (Mandatory)
- Server: The Active Directory server where the user account should be created. (Mandatory)
- ExpirationDate: (Optional) The date when the user account should expire.
- PasswordLength: (Optional) The length of the generated password. Default is 15 characters
### Example Usage

```New-OneOffADUser -FirstName "Alex" -LastName "Morohai" -Username "francys04" -Reason "Testing user creation" -Server "server1" -ExpirationDate "2022-07-31"```

#### Notes
- Ensure that you have administrative privileges and connectivity to the specified Active Directory server.
- The function generates a secure random password containing alphanumeric and special characters.
- The function handles the creation of the user account with the provided parameters.
#### Important Considerations
- This script is provided as-is and without warranty. Use it responsibly and test thoroughly in a controlled environment before deploying in a production setting.
- Be cautious when setting expiration dates, as incorrect dates may result in unexpected behavior.
- Always adhere to your organization's policies and security best practices when managing user accounts in Active Directory.
## Functions and Parameterns for User Mnagment
### New-UserName
- This function generates a unique username based on the user's first name and last name. It ensures that the generated username does not clash with existing usernames in the Active Directory.

### Parameters
- FirstName: The first name of the user. (Mandatory)
- LastName: The last name of the user. (Mandatory)
- Server: The Active Directory server where the user account should be checked for uniqueness. (Mandatory)
### Example Usage
```$uniqueUsername = New-UserName -FirstName "John" -LastName "Doe" -Server "jacked.ca"```

### New-OneOffADUser
- This function creates a new Active Directory user account with customizable options.

### Parameters
- FirstName: The first name of the user. (Mandatory)
- LastName: The last name of the user. (Mandatory)
- Username: (Optional) The desired username. If not provided, a username will be generated using the New-UserName function.
- Reason: A description or reason for creating the user account. (Mandatory)
- Server: The Active Directory server where the user account should be created. (Mandatory)
- ExpirationDate: (Optional) The date when the user account should expire.
- PasswordLength: (Optional) The length of the generated password. Default is 15 characters.
- ChangePasswordAtNextLogon: (Optional) Set to $true if the user should be prompted to change their password at the next logon. Default is $true.
### Example Usage
```New-OneOffADUser -FirstName "Jane" -LastName "Smith" -Reason "Temporary Employee" -Server "jacked.ca" -ExpirationDate "2022-04-30" -PasswordLength 15```
### Important Notes
- This script requires administrative privileges to create user accounts in Active Directory.
- Ensure that you have the necessary permissions and connectivity to the Active Directory server.
- Use the functions responsibly and follow your organization's policies for user account creation and management.
### Disclaimer
- This script is provided as-is and without warranty. Use it at your own risk. The script author is not responsible for any misuse, data loss, or any other consequences resulting from the use of this script.

