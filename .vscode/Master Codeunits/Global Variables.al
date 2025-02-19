codeunit 50140 "Sacco Global Variabless"
{
    SingleInstance = true;

    var
        CurrentUserEmail: Text[80];

    procedure SetUserEmail(NewEmail: Text[80])
    begin
        CurrentUserEmail := NewEmail;
    end;

    procedure GetUserEmail(): Text[80]
    begin
        exit(CurrentUserEmail);
    end;

    // procedure GetUserEmail(): Text[70]
    // begin
    //     exit (CurrentUserEmail);
    // end;
}