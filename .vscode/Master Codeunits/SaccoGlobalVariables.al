codeunit 50104 "Sacco Global Variables"
{
    var
        UserEmail: Text[80]; // Variable to store the logged-in user's email

    procedure SetUserEmail(Email: Text)
    begin
        UserEmail := Email; // Set the user email
    end;

    procedure GetUserEmail(): Text
    begin
        exit(UserEmail); // Return the stored user email
    end;
}