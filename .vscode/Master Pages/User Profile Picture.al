page 50120 "Multiple User Profiles"
{
    PageType = ListPart;
    SourceTable = "Sacco User";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            group(ProfilePicture)
            {
                ShowCaption = false;
                field(UserProfilePicture; Rec."Profile Picture")
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    ToolTip = 'Shows the user profile picture';
                }

                field(UserName; Rec."User Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                    StyleExpr = 'Strong';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange("User ID", UserId);
    end;
}