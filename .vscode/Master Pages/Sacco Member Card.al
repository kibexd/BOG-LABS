page 50106 "Sacco Member Card"
{
    PageType = Card;
    SourceTable = "Sacco User";
    Caption = 'Member Card';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General Information';

                group(ProfilePicture)
                {
                    Caption = 'Profile Picture';
                    ShowCaption = false;

                    field(Image; Rec.Image)
                    {
                        ApplicationArea = All;
                        ShowCaption = false;
                        ToolTip = 'Shows the member''s profile picture.';

                        trigger OnDrillDown()
                        var
                            InStr: InStream;
                            OutStr: OutStream;
                            FileName: Text;
                            PictureExists: Boolean;
                        begin
                            if Rec."User ID" <> GetCurrentUserID() then
                                Error('You can only update your own profile picture.');

                            PictureExists := Rec.Image.Count > 0;

                            if PictureExists then
                                if not Confirm('Do you want to replace the existing picture?') then
                                    exit;

                            if UploadIntoStream('Add Picture', '', 'All Files (*.*)|*.*|Image Files (*.jpg;*.jpeg;*.png;*.bmp;*.gif)|*.jpg;*.jpeg;*.png;*.bmp;*.gif', FileName, InStr) then begin
                                Clear(Rec.Image);
                                Rec.Image.ImportStream(InStr, FileName);
                                Rec.Modify(true);
                                Message('Profile picture updated successfully.');
                            end;
                        end;
                    }
                }

                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("User Name"; Rec."User Name")
                {
                    ApplicationArea = All;
                }
                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = All;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = All;
                }
                field("Email"; Rec.Email)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = All;
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = All;
                }
            }

            group(FinancialInfo)
            {
                Caption = 'Financial Information';

                field(Savings; Rec.Savings)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Loan Balance"; Rec."Loan Balance")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Next Payment Date"; Rec."Next Payment Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }

        area(factboxes)
        {
            part(MemberDetails; "Member Details FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "User ID" = field("User ID");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(UpdatePicture)
            {
                ApplicationArea = All;
                Caption = 'Update Profile Picture';
                Image = Picture;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Update your profile picture';
                Visible = IsCurrentUser;

                trigger OnAction()
                var
                    InStr: InStream;
                    FileName: Text;
                begin
                    if Rec."User ID" <> GetCurrentUserID() then
                        Error('You can only update your own profile picture.');

                    if Rec.Image.Count > 0 then
                        if not Confirm('Do you want to replace the existing picture?') then
                            exit;

                    if UploadIntoStream('Add Picture', '', 'All Files (*.*)|*.*|Image Files (*.jpg;*.jpeg;*.png;*.bmp;*.gif)|*.jpg;*.jpeg;*.png;*.bmp;*.gif', FileName, InStr) then begin
                        Clear(Rec.Image);
                        Rec.Image.ImportStream(InStr, FileName);
                        Rec.Modify(true);
                        Message('Profile picture updated successfully.');
                    end;
                end;
            }
        }
    }

    var
        IsCurrentUser: Boolean;

    trigger OnOpenPage()
    begin
        IsCurrentUser := (Rec."User ID" = GetCurrentUserID());
    end;

    local procedure GetCurrentUserID(): Code[20]
    var
        SaccoUser: Record "Sacco User";
        GlobalVar: Codeunit "Sacco Global Variabless";
        UserEmail: Text;
    begin
        UserEmail := GlobalVar.GetUserEmail();
        if UserEmail = '' then
            exit('');

        SaccoUser.Reset();
        SaccoUser.SetRange(Email, UserEmail);
        if SaccoUser.FindFirst() then
            exit(SaccoUser."User ID")
        else
            exit('');
    end;
}