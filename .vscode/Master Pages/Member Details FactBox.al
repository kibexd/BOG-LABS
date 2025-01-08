page 50135 "Member Details FactBox"
{
    PageType = CardPart;
    SourceTable = "Sacco User";
    Caption = 'Member Details';

    layout
    {
        area(content)
        {
            group(General)
            {
                ShowCaption = false;

                field(Image; Rec.Image)
                {
                    ApplicationArea = All;
                    ShowCaption = false;

                    trigger OnDrillDown()
                    var
                        InStr: InStream;
                        FileName: Text;
                        GlobalVar: Codeunit "Sacco Global Variabless";
                    begin
                        // Check if this is the current user's profile
                        if Rec.Email <> GlobalVar.GetUserEmail() then
                            Error('You can only update your own profile picture.');

                        if Rec.Image.Count > 0 then
                            if not Confirm('Do you want to replace your existing profile picture?') then
                                exit;

                        if UploadIntoStream('Select Profile Picture', '',
                            'Image Files (*.jpg;*.jpeg;*.png;*.bmp;*.gif)|*.jpg;*.jpeg;*.png;*.bmp;*.gif|All Files (*.*)|*.*',
                            FileName, InStr) then begin
                            Clear(Rec.Image);
                            Rec.Image.ImportStream(InStr, FileName);
                            Rec.Modify(true);
                            Message('Profile picture updated successfully!');
                            CurrPage.Update(false);
                        end;
                    end;
                }

                field("User Name"; Rec."User Name")
                {
                    ApplicationArea = All;
                    StyleExpr = 'Strong';
                    Editable = false;
                }

                field("Registration Time"; Rec."Registration Time")
                {
                    ApplicationArea = All;
                    StyleExpr = 'Standard';
                    Editable = false;
                }

                field("Savings"; Rec.Savings)
                {
                    ApplicationArea = All;
                    StyleExpr = 'Favorable';
                    Editable = false;
                }

                field("Loan Balance"; Rec."Loan Balance")
                {
                    ApplicationArea = All;
                    StyleExpr = LoanBalanceStyle;
                    Editable = false;
                }

                field("Next Payment Date"; Rec."Next Payment Date")
                {
                    ApplicationArea = All;
                    StyleExpr = PaymentDateStyle;
                    Editable = false;
                }

                field(Location; Rec.Location)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field(Gender; Rec.Gender)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field(UpdatePictureField; UpdatePictureLbl)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    StyleExpr = 'Strong';
                    Visible = IsCurrentUser;

                    trigger OnDrillDown()
                    var
                        InStr: InStream;
                        FileName: Text;
                    begin
                        if UploadIntoStream('Select Profile Picture', '',
                            'Image Files (*.jpg;*.jpeg;*.png;*.bmp;*.gif)|*.jpg;*.jpeg;*.png;*.bmp;*.gif|All Files (*.*)|*.*',
                            FileName, InStr) then begin
                            Clear(Rec.Image);
                            Rec.Image.ImportStream(InStr, FileName);
                            Rec.Modify(true);
                            Message('Profile picture updated successfully!');
                            CurrPage.Update(false);
                        end;
                    end;
                }
            }
        }
    }

    var
        LoanBalanceStyle: Text;
        PaymentDateStyle: Text;
        IsCurrentUser: Boolean;
        UpdatePictureLbl: Label 'Update Profile Picture';

    trigger OnOpenPage()
    var
        GlobalVar: Codeunit "Sacco Global Variabless";
    begin
        IsCurrentUser := (Rec.Email = GlobalVar.GetUserEmail());
    end;

    trigger OnAfterGetRecord()
    begin
        // Set styles based on conditions
        LoanBalanceStyle := SetLoanBalanceStyle();
        PaymentDateStyle := SetPaymentDateStyle();

        // Update IsCurrentUser
        IsCurrentUser := (Rec.Email = GetCurrentUserEmail());
    end;

    local procedure SetLoanBalanceStyle(): Text
    begin
        if Rec."Loan Balance" = 0 then
            exit('Favorable')
        else
            exit('Attention');
    end;

    local procedure SetPaymentDateStyle(): Text
    begin
        if Rec."Next Payment Date" < Today then
            exit('Unfavorable')
        else if Rec."Next Payment Date" = Today then
            exit('Attention')
        else
            exit('Standard');
    end;

    local procedure GetCurrentUserEmail(): Text
    var
        GlobalVar: Codeunit "Sacco Global Variabless";
    begin
        exit(GlobalVar.GetUserEmail());
    end;
}