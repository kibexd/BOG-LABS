page 50119 "User Profile Part"
{
    PageType = CardPart;
    SourceTable = "Sacco User";
    Caption = 'User Profile';

    layout
    {
        area(Content)
        {
            group(ProfileInfo)
            {
                ShowCaption = false;

                field("User ID"; Rec."User ID") // Ensure this matches the table definition
                {
                    ApplicationArea = All;
                    Caption = 'Member ID';
                    Editable = false;
                }

                field("User Name"; Rec."User Name")
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                    Editable = false;
                }

                // Add more profile fields as needed
            }
        }
    }
}
