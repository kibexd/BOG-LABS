// Page Overview
// This page is designed to provide a simple and intuitive interface for users to select their desired action,
// whether it's to log in to their existing account or to register for a new one.
// The page allows users to enter their credentials, such as email and password, and also upload a profile picture.

// Variables and Data Types
// ActionType: This is an option variable that determines whether the user is logging in or registering.
// It is defined as Option Login,Register, which means it can only take one of these two values.
// FirstName, LastName, Username, Email, Password, ConfirmPassword, PhoneNo, Gender, Location:
// These are text variables that store user input data, such as their name, email address, and phone number.
// Role: This is an option variable that determines the user's role, which can be either Member or Admin.
// It is defined as Option Member,Admin, which means it can only take one of these two values.
// ActionButtonCaption: This is a text variable that stores the caption for the action button,
// which is the button that the user clicks to perform the selected action.
// IsProfilePictureUploaded: This is a boolean variable that indicates whether a profile picture has been uploaded.
// It can only take one of two values: true or false.
// TempBlob: This is a codeunit variable that handles temporary blob storage,
// which is used to store the uploaded profile picture temporarily before it is saved to the database.
// FileInstream and FileOutstream: These are InStream and OutStream variables that handle file uploads,
// which are used to read and write files, such as the uploaded profile picture.

// Layout
// The page is divided into several sections to make it easier to organize and manage the content.
// area(Content): This is the main content area of the page, which contains all the fields and controls.
// group(Overview): This is a group that contains the action type selection and role selection,
// which allows the user to select their desired action and role.
// group(LoginSection) and group(RegistrationSection):
// These are groups that contain the login and registration fields, respectively,
// which are used to collect user input data, such as email and password.
// group(ActionButton): This is a group that contains the action button,
// which is the button that the user clicks to perform the selected action.
// area(FactBoxes): This is an area that contains fact boxes, including the logo and action buttons,
// which are used to display additional information and provide quick access to common actions.

/// <summary>
/// Page Sacco Login and Registration (ID 50100).
/// Provides interface for user authentication and new account registration.
/// </summary>
page 50100 "Sacco Login and Registration" // This defines a page for logging in and registering users
{
    PageType = Card; // The type of page is a card
    ApplicationArea = All; // This page is available in all application areas
    UsageCategory = Administration; // This page is categorized under administration
    Caption = '🕇 Murima Sacco - Login and Registration'; // The title of the page
    SourceTable = "Sacco User";

    layout // This section defines how the page is laid out
    {
        area(Content) // This is the main content area of the page
        {
            group(Overview) // This group contains the action selection
            {
                Caption = '🔄 Select Action'; // Title for the action selection group
                field(ActionType; ActionType) // This field allows the user to select Login or Register
                {
                    ApplicationArea = All; // This field is available in all application areas
                    Caption = 'Action'; // Label for the field
                    ToolTip = 'Select Login or Register'; // Help text when hovering over the field
                    OptionCaption = 'Login,Register'; // Options available in the field
                    trigger OnValidate() // This code runs when the user selects an option
                    begin
                        UpdateActionButton(); // Calls a function to update the action button based on selection
                    end;
                }

                field(Role; Role) // This field allows the user to select their role (Member or Admin)
                {
                    ApplicationArea = All; // This field is available in all application areas
                    Caption = 'Role'; // Label for the field
                    ToolTip = 'Select your role'; // Help text when hovering over the field
                    OptionCaption = 'Member,Admin'; // Options available in the field
                }
            }

            group(LoginSection) // This group contains fields for logging in
            {
                Caption = '🔑 Login Here'; // Title for the login section
                Visible = (ActionType = ActionType::Login); // This section is visible only if Login is selected

                field(EmailLogin; Email) // Field for entering email during login
                {
                    ApplicationArea = All; // This field is available in all application areas
                    Caption = 'Email'; // Label for the field
                    ToolTip = 'Enter your email address'; // Help text when hovering over the field
                    ExtendedDatatype = EMail; // This field expects an email format
                }
                field(PasswordLogin; Password) // Field for entering password during login
                {
                    ApplicationArea = All; // This field is available in all application areas
                    Caption = 'Password'; // Label for the field
                    ToolTip = 'Enter your password'; // Help text when hovering over the field
                    ExtendedDatatype = Masked; // This field hides the password input
                }
            }

            group(RegistrationSection) // This group contains fields for registering a new user
            {
                Caption = '📝 Register Here'; // Title for the registration section
                Visible = (ActionType = ActionType::Register); // This section is visible only if Register is selected

                field(Username; Username) // Field for entering username during registration
                {
                    ApplicationArea = All; // This field is available in all application areas
                    Caption = 'Username'; // Label for the field
                    ToolTip = 'Enter your username (e.g., user123)'; // Help text when hovering over the field
                }
                field(FirstName; FirstName) // Field for entering first name
                {
                    ApplicationArea = All; // This field is available in all application areas
                    Caption = 'First Name'; // Label for the field
                    ToolTip = 'Enter your first name (e.g., Enock)'; // Help text when hovering over the field
                }
                field(LastName; LastName) // Field for entering last name
                {
                    ApplicationArea = All; // This field is available in all application areas
                    Caption = 'Last Name'; // Label for the field
                    ToolTip = 'Enter your last name (e.g., Kipkoech)'; // Help text when hovering over the field
                }
                field(EmailRegister; Email) // Field for entering email during registration
                {
                    ApplicationArea = All; // This field is available in all application areas
                    Caption = 'Email'; // Label for the field
                    ToolTip = 'Enter your email address (e.g., user@example.com)'; // Help text when hovering over the field
                    ExtendedDatatype = EMail; // This field expects an email format
                }
                field(PasswordRegister; Password) // Field for entering password during registration
                {
                    ApplicationArea = All; // This field is available in all application areas
                    Caption = 'Password'; // Label for the field
                    ToolTip = 'Enter a secure password'; // Help text when hovering over the field
                    ExtendedDatatype = Masked; // This field hides the password input
                }
                field(ConfirmPassword; ConfirmPassword) // Field for confirming the password
                {
                    ApplicationArea = All; // This field is available in all application areas
                    Caption = 'Confirm Password'; // Label for the field
                    ToolTip = 'Re-enter your password'; // Help text when hovering over the field
                    ExtendedDatatype = Masked; // This field hides the password input
                }
                field(PhoneNo; PhoneNo) // Field for entering phone number
                {
                    ApplicationArea = All; // This field is available in all application areas
                    Caption = 'Phone Number'; // Label for the field
                    ToolTip = 'Enter your phone number (e.g., +254700000000)'; // Help text when hovering over the field
                }
                field(Gender; Gender) // Field for selecting gender
                {
                    ApplicationArea = All; // This field is available in all application areas
                    Caption = 'Gender'; // Label for the field
                    ToolTip = 'Select your gender'; // Help text when hovering over the field
                }
                field(Location; Location) // Field for entering location
                {
                    ApplicationArea = All; // This field is available in all application areas
                    Caption = 'Location'; // Label for the field
                    ToolTip = 'Enter your location (e.g., Nairobi)'; // Help text when hovering over the field
                }
                field(UploadPictureBtn; UploadPictureLbl) // Button for uploading a profile picture
                {
                    ApplicationArea = All; // This field is available in all application areas
                    Caption = 'Upload Profile Picture'; // Label for the button
                    ToolTip = 'Click to upload a profile picture'; // Help text when hovering over the button

                    trigger OnDrillDown() // This code runs when the button is clicked
                    begin
                        UploadProfilePicture(); // Calls a function to upload the profile picture
                    end;
                }
                field(ProfilePictureUploaded; IsProfilePictureUploaded) // Field showing if a profile picture is uploaded
                {
                    ApplicationArea = All; // This field is available in all application areas
                    Caption = 'Profile Picture Status'; // Label for the field
                    Editable = false; // This field cannot be edited
                    Style = Favorable; // This field has a favorable style
                    StyleExpr = IsProfilePictureUploaded; // The style depends on whether a picture is uploaded
                }

                field(PasswordStrength; PasswordStrengthText) // Field for displaying the uploaded profile picture
                {
                    ApplicationArea = All; // This field is available in all application areas
                    Caption = 'Password Strength'; // Label for the field
                    Editable = false; // This field cannot be edited
                    Style = Strong;
                    StyleExpr = IsStrongPassword; // The style depends on the password strength

                    trigger OnValidate() // This code runs when the user enters or changes the password
                    begin
                        UpdatePasswordStrength(); // Calls a function to update the password strength
                    end;
                }
            }

            group(ActionButton) // This group contains the action button
            {
                ShowCaption = false; // Do not show the caption for this group
                field(ActionButtonField; ActionButtonCaption) // Field for the action button
                {
                    ApplicationArea = All; // This field is available in all application areas
                    ShowCaption = false; // Do not show the caption for this field
                    Editable = false; // This field cannot be edited

                    trigger OnDrillDown() // This code runs when the button is clicked
                    begin
                        PerformAction(); // Calls a function to perform the login or registration action
                    end;
                }
            }
        }

        area(FactBoxes) // This area contains additional information boxes
        {
            part(Logo; "MSacco Logo") // Part for displaying the logo
            {
                ApplicationArea = All; // This part is available in all application areas
            }
            part(ActionButtons; "Login Action Buttons") // Part for displaying action buttons
            {
                ApplicationArea = All; // This part is available in all application areas
            }
        }
    }

    var // This section declares variables used in the page
        ActionType: Option Login,Register; // Variable to store the selected action (Login or Register)
        FirstName: Text[50]; // Variable to store the first name (up to 50 characters)
        LastName: Text[50]; // Variable to store the last name (up to 50 characters)
        Username: Text[50]; // Variable to store the username (up to 50 characters)
        Email: Text[80]; // Variable to store the email (up to 80 characters)
        Password: Text[250]; // Variable to store the password (up to 250 characters)
        ConfirmPassword: Text[250]; // Variable to store the confirmed password (up to 250 characters)
        Role: Option Member,Admin; // Variable to store the selected role (Member or Admin)
        ActionButtonCaption: Text; // Variable to store the caption for the action button
        PhoneNo: Text[20]; // Variable to store the phone number (up to 20 characters)
        Gender: Option Male,Female,Other; // Variable to store the selected gender
        Location: Text[100]; // Variable to store the location (up to 100 characters)
        UserManagement: Codeunit "Sacco User Management"; // Variable for user management codeunit
        SelectPictureTxt: Label 'Select a picture to upload'; // Label for selecting a picture
        TempBlob: Codeunit "Temp Blob"; // Variable for temporary blob storage
        FileInstream: InStream; // Variable for reading file input
        FileOutstream: OutStream; // Variable for writing file output
        FileName: Text; // Variable to store the file name
        IsProfilePictureUploaded: Boolean; // Variable to indicate if a profile picture is uploaded
        UploadPictureLbl: Label 'Upload Picture'; // Label for the upload picture button
        GlobalVar: Codeunit "Sacco Global Variables"; // Add this line to declare the global variable codeunit
        IsStrongPassword: Boolean; // Variable to indicate if the password is strong
        PasswordStrengthText: Text; // Variable to store the password strength text

    trigger OnOpenPage() // This code runs when the page is opened
    begin
        UpdateActionButton(); // Calls a function to update the action button based on the selected action
    end;

    /// <summary>
    /// Updates the action button caption based on the selected action type.
    /// </summary>
    procedure UpdateActionButton() // This function updates the action button caption
    begin
        if ActionType = ActionType::Login then // Check if the action is Login
            ActionButtonCaption := '🔑 Login' // Set the button caption to Login
        else
            ActionButtonCaption := '📝 Register'; // Otherwise, set it to Register
    end;

    /// <summary>
    /// Handles the upload of a user's profile picture and stores it in a temporary blob.
    /// </summary>
    procedure UploadProfilePicture() // This function handles uploading a profile picture
    var
        FromFileName: Text; // Variable to store the name of the file being uploaded
    begin
        if UploadIntoStream(SelectPictureTxt, '', 'All Files (*.*)|*.*', FromFileName, FileInstream) then begin // Check if the file upload is successful
            TempBlob.CreateOutStream(FileOutstream); // Create an output stream for the temporary blob
            CopyStream(FileOutstream, FileInstream); // Copy the uploaded file into the temporary blob
            IsProfilePictureUploaded := true; // Set the flag indicating a profile picture has been uploaded
            Message('Profile picture uploaded successfully.'); // Show a success message
        end;
    end;

    procedure PerformAction() // This function performs the login or registration action
    var
        SaccoUser: Record "Sacco User"; // Variable to store user record
        UserRole: Text; // Variable to store the user's role
        GlobalVar: Codeunit "Sacco Global Variabless";
    begin
        if ActionType = ActionType::Login then begin // Check if the action is Login
            // Login Logic
            if Email = '' then // Check if the email is empty
                Message('Email cannot be empty.'); // Show an error message
            if Password = '' then // Check if the password is empty
                Message('Password cannot be empty.'); // Show an error message

            SaccoUser.Reset(); // Reset the user record
            SaccoUser.SetRange("Email", Email); // Set the range to find the user by email

            if SaccoUser.FindFirst() then begin // Check if the user is found
                if SaccoUser."Password" = Password then begin // Check if the password matches
                    // Store the user's email in a global variable or app setting
                    GlobalVar.SetUserEmail(SaccoUser.Email);  // You'll need to create this global variable codeunit
                    UserRole := Format(SaccoUser."User Role"); // Get the user's role
                    if (UserRole = 'Admin') and (Role = Role::Admin) then begin // Check if the user is an Admin
                        Close(); // Close the page
                        Message('Login successful. Redirecting to the Admin Dashboard...'); // Show success message
                        Page.Run(Page::"Sacco Admin Dashboard"); // Redirect to Admin Dashboard
                    end
                    else if (UserRole = 'Member') and (Role = Role::Member) then begin // Check if the user is a Member
                        Close(); // Close the page
                        Message('Login successful. Redirecting to the Member Dashboard...'); // Show success message
                        Page.Run(Page::"Sacco Member Dashboaard"); // Redirect to Member Dashboard
                    end
                    else
                        Message('Unauthorized role, please try another role.'); // Show error message for unauthorized role
                end
                else
                    Message('Invalid email or password. Please try again.'); // Show error message for invalid credentials
            end
            else
                Message('Invalid email or password. Please try again.'); // Show error message if user not found
        end
        else if ActionType = ActionType::Register then begin // Check if the action is Register
            // Registration Logic
            if Email = '' then // Check if the email is empty
                Message('Email cannot be empty.'); // Show an error message
            if Password = '' then // Check if the password is empty
                Message('Password cannot be empty.'); // Show an error message
            if Username = '' then // Check if the username is empty
                Message('Username cannot be empty.'); // Show an error message
            if Password <> ConfirmPassword then begin // Check if passwords match
                Message('Passwords do not match. Please try again.'); // Show error message for mismatched passwords
                exit; // Exit the procedure
            end;

            // Check for unique email
            SaccoUser.Reset(); // Reset the user record
            SaccoUser.SetRange("Email", Email); // Set the range to find the user by email
            if SaccoUser.FindFirst() then // Check if the user is found
                Message('An account with this email already exists.'); // Show error message for existing email

            // Check for unique username
            SaccoUser.SetRange("User Name", Username); // Set the range to find the user by username
            if SaccoUser.FindFirst() then // Check if the user is found
                Message('An account with this username already exists.'); // Show error message for existing username

            // Validate password complexity
            if not IsValidPassword(Password) then // Check if the password is valid
                Message('Password must contain at least one uppercase letter and one number.'); // Show error message for invalid password

            SaccoUser.Init(); // Initialize a new user record
            SaccoUser."User ID" := UserManagement.GenerateUniqueUserID(); // Generate a unique user ID
            SaccoUser."First Name" := FirstName; // Set the first name
            SaccoUser."Last Name" := LastName; // Set the last name
            SaccoUser."Email" := Email; // Set the email
            SaccoUser."Password" := Password; // Set the password
            SaccoUser."User Role" := Role; // Set the user role
            SaccoUser.Status := SaccoUser.Status::Active; // Set the user status to active
            SaccoUser.Insert(); // Insert the new user record into the database
            Message('Registration successful. You may now login.'); // Show success message for registration
        end;
    end;

    procedure IsValidPassword(pwd: Text): Boolean // This function checks if the password is valid
    var
        i: Integer; // Variable for loop index
        HasUpper: Boolean; // Variable to check for uppercase letters
        HasDigit: Boolean; // Variable to check for digits
    begin
        HasUpper := false; // Initialize uppercase check to false
        HasDigit := false; // Initialize digit check to false
        for i := 1 to StrLen(pwd) do begin // Loop through each character in the password
            if pwd[i] = UpperCase(pwd[i]) then // Check if the character is uppercase
                HasUpper := true; // Set uppercase check to true
            if (pwd[i] >= '0') and (pwd[i] <= '9') then // Check if the character is a digit
                HasDigit := true; // Set digit check to true
        end;
        exit(HasUpper and HasDigit); // Return true if both checks are true
    end;

    procedure UpdatePasswordStrength()
    var
        Score: Integer; // Variable to store the password strength score
    begin
        Score := 0;
        if StrLen(Password) >= 8 then
            Score += 1;
        if ContainsUpperCase(Password) then
            Score += 1;
        if ContainsLowerCase(Password) then
            Score += 1;
        if ContainsNumber(Password) then
            Score += 1;
        if ContainsSpecialChar(Password) then
            Score += 1;

        case Score of
            0 .. 1:
                begin
                    PasswordStrengthText := '❌ Weak';
                    IsStrongPassword := false;
                end;
            2 .. 3:
                begin
                    PasswordStrengthText := '⚠️ Medium';
                    IsStrongPassword := false;
                end;
            4 .. 5:
                begin
                    PasswordStrengthText := '✅ Strong';
                    IsStrongPassword := true;
                end;
        end;
    end;

    procedure ContainsUpperCase(InputText: Text): Boolean
    begin
        exit(InputText <> LowerCase(InputText));
    end;

    procedure ContainsLowerCase(InputText: Text): Boolean
    begin
        exit(InputText <> UpperCase(InputText));
    end;

    procedure ContainsNumber(InputText: Text): Boolean
    var
        i: Integer;
    begin
        for i := 1 to StrLen(InputText) do
            if (InputText[i] >= '0') and (InputText[i] <= '9') then
                exit(true);
        exit(false);
    end;

    procedure ContainsSpecialChar(InputText: Text): Boolean
    var
        SpecialChars: Text;
        i: Integer;
    begin
        SpecialChars := '!@#$%^&*()_+-=[]{}|;:,.<>?';
        for i := 1 to StrLen(InputText) do
            if StrPos(SpecialChars, Format(InputText[i])) > 0 then
                exit(true);
        exit(false);
    end;
}
