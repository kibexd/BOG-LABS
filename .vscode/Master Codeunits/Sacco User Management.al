codeunit 50101 "Sacco User Management"
{
    // This procedure generates a unique user ID for new members
    procedure GenerateUniqueUserID(): Code[20]
    var
        SaccoUser: Record "Sacco User";  // Record to hold existing users
        NewUserID: Code[20];             // Variable for the new user ID
        LastUserID: Integer;             // Variable for the last used user ID
    begin
        // Find the last user ID in the database
        if SaccoUser.FindLast() then begin
            // Try to convert the last ID into a number
            if not Evaluate(LastUserID, SaccoUser."User ID") then
                LastUserID := 0; // If conversion fails, start from 0
            LastUserID += 1;  // Increment to get the next ID
        end else
            LastUserID := 1;  // Start with 1 if no users exist

        // Format the new user ID with leading zeros
        NewUserID := Format(LastUserID, 6, '<Integer,6><Filler Character,0>');
        exit(NewUserID); // Return the new user ID
    end;

    // This procedure retrieves the current user based on their email
    procedure GetCurrentUser(var SaccoUser: Record "Sacco User"): Boolean
    var
        UserSetup: Record "User Setup";  // Record for user setup information
    begin
        // Try to find the user's setup information
        if not UserSetup.Get(UserSecurityId()) then
            exit(false); // Return false if user setup is not found

        // Look for a member with the matching email
        SaccoUser.Reset();
        SaccoUser.SetRange("Email", UserSetup."E-Mail");
        exit(SaccoUser.FindFirst()); // Return true if user is found
    end;

    // This procedure validates if the user has access
    procedure ValidateUserAccess(): Boolean
    var
        SaccoUser: Record "Sacco User"; // Record for user information
    begin
        // Check if the user exists
        if not GetCurrentUser(SaccoUser) then
            Error('User not found in the system. Please contact administrator.');

        // Check if the user's account is active
        if SaccoUser.Status <> SaccoUser.Status::Active then
            Error('Your account is not active. Please contact administrator.');

        exit(true); // Return true if access is valid
    end;

    // This procedure retrieves a user by their email
    procedure GetUserByEmail(Email: Text; var SaccoUser: Record "Sacco User"): Boolean
    begin
        SaccoUser.Reset();  // Clear any previous searches
        // Set the range to find the user by email (case insensitive)
        SaccoUser.SetRange("Email", LowerCase(Email));
        exit(SaccoUser.FindFirst()); // Return true if user is found
    end;
}
