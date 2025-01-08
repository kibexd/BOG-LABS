page 50105 "Sacco Member List"
{
    PageType = List;
    SourceTable = "Sacco User";
    CardPageID = 50106;
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;
    InsertAllowed = false;  // Only allow creation through registration
    ModifyAllowed = true;   // Allow modifications
    DeleteAllowed = false;  // Don't allow deletion from list

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;

                field(Image; Rec.Image)
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the profile picture of the member.';
                    ShowCaption = false;

                    trigger OnDrillDown()
                    var
                        Selection: Integer;
                        SelectionTxt: Text;
                    begin
                        if not IsCurrentUser then
                            exit;  // Only show menu for current user's picture

                        SelectionTxt := 'What would you like to do?\';
                        SelectionTxt += '\Take Picture';
                        SelectionTxt += '\Import Picture';
                        SelectionTxt += '\Export Picture';
                        SelectionTxt += '\Delete Picture';

                        Selection := Dialog.StrMenu(SelectionTxt, 1, 'Profile Picture Options');

                        case Selection of
                            1:  // Take Picture
                                begin
                                    if not CameraAvailable then
                                        Error('Camera is not available on this device.');
                                    TakeNewPicture();
                                end;
                            2:  // Import Picture
                                begin
                                    ImportNewPicture();
                                end;
                            3:  // Export Picture
                                begin
                                    ExportCurrentPicture();
                                end;
                            4:  // Delete Picture
                                begin
                                    DeleteCurrentPicture();
                                end;
                        end;
                    end;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ID of the Sacco member.';
                }
                field("User Name"; Rec."User Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the Sacco member.';
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
                    ToolTip = 'Specifies the email address of the Sacco member.';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                }
                field("User Role"; Rec."User Role")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the role of the Sacco member.';
                }
                field("Status"; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the Sacco member.';
                }
            }
        }
        area(factboxes)
        {
            part(MemberDetails; "Member Details FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "User ID" = field("User ID");
                UpdatePropagation = SubPart;
            }
            part(LoanHistory; "Member Loan History")
            {
                ApplicationArea = All;
                SubPageLink = "Member ID" = field("User ID");
                Visible = ShowLoanHistory;
            }
            part(PaymentHistory; "Member Payment History")
            {
                ApplicationArea = All;
                SubPageLink = "Member ID" = field("User ID");
                Visible = ShowPaymentHistory;
            }
            systempart(Links; Links)
            {
                ApplicationArea = RecordLinks;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(MemberCard)
            {
                ApplicationArea = All;
                Caption = 'Member Card';
                Image = Card;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Sacco Member Card";
                RunPageLink = "User ID" = field("User ID");
                ToolTip = 'View or edit detailed member information.';
            }

            action(UpdatePicture)
            {
                ApplicationArea = All;
                Caption = 'Update Picture';
                Image = Picture;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Update your profile picture.';
                Visible = IsCurrentUser;

                trigger OnAction()
                var
                    InStr: InStream;
                    FromFileName: Text;
                begin
                    if Rec."User ID" <> GetCurrentUserID() then
                        Error('You can only update your own profile picture.');

                    if UploadIntoStream('Select Picture...', '', 'All Files (*.*)|*.*', FromFileName, InStr) then begin
                        Clear(Rec.Image);
                        Rec.Image.ImportStream(InStr, FromFileName);
                        Rec.Modify(true);
                    end;
                end;
            }
        }
        area(Processing)
        {
            action(Refresh)
            {
                ApplicationArea = All;
                Caption = 'Refresh List';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Refresh the list of members.';

                trigger OnAction()
                begin
                    CurrPage.Update(false);
                end;
            }
            action(TakePicture)
            {
                ApplicationArea = All;
                Caption = 'Take Picture';
                Image = Camera;
                ToolTip = 'Activate the camera on the device.';
                Visible = CameraAvailable and IsCurrentUser;

                trigger OnAction()
                begin
                    TakeNewPicture();
                end;
            }
            action(ImportPicture)
            {
                ApplicationArea = All;
                Caption = 'Import Picture';
                Image = Import;
                ToolTip = 'Import a picture file.';
                Visible = IsCurrentUser;

                trigger OnAction()
                var
                    InStr: InStream;
                    FileName: Text;
                begin
                    if Rec."User ID" <> GetCurrentUserID() then
                        Error('You can only update your own profile picture.');

                    if Rec.Image.Count > 0 then
                        if not Confirm(OverrideImageQst) then
                            exit;

                    if UploadIntoStream('Select Picture...', '', 'Image Files (*.jpg;*.jpeg;*.png;*.bmp;*.gif)|*.jpg;*.jpeg;*.png;*.bmp;*.gif|All Files (*.*)|*.*', FileName, InStr) then begin
                        Clear(Rec.Image);
                        Rec.Image.ImportStream(InStr, FileName);
                        Rec.Modify(true);
                        Message('Profile picture updated successfully.');
                    end;
                end;
            }
            action(ExportPicture)
            {
                ApplicationArea = All;
                Caption = 'Export Picture';
                Enabled = HasPicture;
                Image = Export;
                ToolTip = 'Export the picture to a file.';
                Visible = IsCurrentUser;

                trigger OnAction()
                var
                    TenantMedia: Record "Tenant Media";
                    InStr: InStream;
                    ToFile: Text;
                begin
                    if Rec."User ID" <> GetCurrentUserID() then
                        Error('You can only export your own profile picture.');

                    if Rec.Image.Count <= 0 then
                        Error('No picture to export.');

                    ToFile := StrSubstNo('%1_%2.jpg', Rec."User ID", Rec."User Name");

                    // Get the first media from MediaSet
                    if TenantMedia.Get(Rec.Image.Item(1)) then begin
                        TenantMedia.CalcFields(Content);
                        if TenantMedia.Content.HasValue then begin
                            TenantMedia.Content.CreateInStream(InStr);
                            DownloadFromStream(
                                InStr,
                                'Export Picture',
                                '',
                                'All Files (*.*)|*.*',
                                ToFile
                            );
                            Message('Picture exported successfully.');
                        end else
                            Error('No picture content found.');
                    end else
                        Error('Could not find the picture to export.');
                end;
            }
            action(DeletePicture)
            {
                ApplicationArea = All;
                Caption = 'Delete Picture';
                Enabled = HasPicture;
                Image = Delete;
                ToolTip = 'Delete the picture.';
                Visible = IsCurrentUser;

                trigger OnAction()
                begin
                    if Rec."User ID" <> GetCurrentUserID() then
                        Error('You can only delete your own profile picture.');

                    if not Confirm(DeleteImageQst) then
                        exit;

                    Clear(Rec.Image);
                    Rec.Modify(true);
                end;
            }
        }
    }

    var
        ShowLoanHistory: Boolean;
        ShowPaymentHistory: Boolean;
        IsCurrentUser: Boolean;
        CurrentUserID: Code[20];
        Camera: Codeunit Camera;
        [InDataSet]
        CameraAvailable: Boolean;
        OverrideImageQst: Label 'The existing picture will be replaced. Do you want to continue?';
        DeleteImageQst: Label 'Are you sure you want to delete the picture?';
        SelectPictureTxt: Label 'Select a picture to upload';
        DeleteExportEnabled: Boolean;
        MimeTypeTok: Label 'image/jpeg', Locked = true;
        HasPicture: Boolean;

    trigger OnOpenPage()
    begin
        CameraAvailable := Camera.IsAvailable();
        CurrentUserID := GetCurrentUserID();
        SetViewBasedOnRole();
    end;

    trigger OnAfterGetRecord()
    begin
        IsCurrentUser := (Rec."User ID" = CurrentUserID);
        ShowLoanHistory := IsCurrentUser or IsUserAdmin();
        ShowPaymentHistory := IsCurrentUser or IsUserAdmin();
        SetEditableOnPictureActions();
    end;

    local procedure SetEditableOnPictureActions()
    begin
        HasPicture := Rec.Image.Count > 0;
        DeleteExportEnabled := HasPicture;
    end;

    procedure TakeNewPicture()
    var
        PictureInstream: InStream;
        PictureDescription: Text;
    begin
        if Rec."User ID" <> GetCurrentUserID() then
            Error('You can only update your own profile picture.');

        if Rec.Image.Count > 0 then
            if not Confirm(OverrideImageQst) then
                exit;

        if Camera.GetPicture(PictureInstream, PictureDescription) then begin
            Clear(Rec.Image);
            Rec.Image.ImportStream(PictureInstream, PictureDescription, MimeTypeTok);
            Rec.Modify(true);
        end;
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

    local procedure IsUserAdmin(): Boolean
    var
        SaccoUser: Record "Sacco User";
        GlobalVar: Codeunit "Sacco Global Variabless";
        UserEmail: Text;
    begin
        UserEmail := GlobalVar.GetUserEmail();

        if UserEmail = '' then
            exit(true);  // For testing, assume admin if no user logged in

        SaccoUser.Reset();
        SaccoUser.SetRange("Email", UserEmail);
        if SaccoUser.FindFirst() then
            exit(SaccoUser."User Role" = SaccoUser."User Role"::Admin);

        exit(false);
    end;

    local procedure SetViewBasedOnRole()
    var
        GlobalVar: Codeunit "Sacco Global Variabless";
        UserEmail: Text;
    begin
        UserEmail := GlobalVar.GetUserEmail();

        // Debug message to check current user
        Message('Current User Email: %1', UserEmail);

        if not IsUserAdmin() then begin
            // If not admin, only show their own record
            Rec.Reset();
            Rec.SetRange("Email", UserEmail);
        end else begin
            // If admin, show all records
            Rec.Reset();
        end;

        // Debug message to show how many records are visible after filtering
        Message('Visible Records: %1', Rec.Count);
    end;

    local procedure EnsureDataExists()
    var
        SaccoUser: Record "Sacco User";
    begin
        if SaccoUser.IsEmpty then begin
            if Confirm('No users found. Would you like to create a test user?') then begin
                CreateTestUser();
                CurrPage.Update(false);
            end;
        end;
    end;

    local procedure CreateTestUser()
    var
        SaccoUser: Record "Sacco User";
        UserMgmt: Codeunit "Sacco User Management";
    begin
        SaccoUser.Init();
        SaccoUser."User ID" := UserMgmt.GenerateUniqueUserID();
        SaccoUser."User Name" := 'Test User';
        SaccoUser."Email" := 'test@example.com';
        SaccoUser."User Role" := SaccoUser."User Role"::Member;
        SaccoUser.Status := SaccoUser.Status::Active;
        SaccoUser.Insert(true);
    end;

    local procedure ImportNewPicture()
    var
        InStr: InStream;
        FileName: Text;
    begin
        if Rec."User ID" <> GetCurrentUserID() then
            Error('You can only update your own profile picture.');

        if Rec.Image.Count > 0 then
            if not Confirm(OverrideImageQst) then
                exit;

        if UploadIntoStream('Select Picture...', '',
            'Image Files (*.jpg;*.jpeg;*.png;*.bmp;*.gif)|*.jpg;*.jpeg;*.png;*.bmp;*.gif|All Files (*.*)|*.*',
            FileName, InStr) then begin
            Clear(Rec.Image);
            Rec.Image.ImportStream(InStr, FileName);
            Rec.Modify(true);
            Message('Profile picture updated successfully.');
        end;
    end;

    local procedure ExportCurrentPicture()
    var
        TenantMedia: Record "Tenant Media";
        InStr: InStream;
        ToFile: Text;
    begin
        if Rec."User ID" <> GetCurrentUserID() then
            Error('You can only export your own profile picture.');

        if Rec.Image.Count <= 0 then
            Error('No picture to export.');

        ToFile := StrSubstNo('%1_%2.jpg', Rec."User ID", Rec."User Name");

        if TenantMedia.Get(Rec.Image.Item(1)) then begin
            TenantMedia.CalcFields(Content);
            if TenantMedia.Content.HasValue then begin
                TenantMedia.Content.CreateInStream(InStr);
                DownloadFromStream(
                    InStr,
                    'Export Picture',
                    '',
                    'All Files (*.*)|*.*',
                    ToFile
                );
                Message('Picture exported successfully.');
            end else
                Error('No picture content found.');
        end else
            Error('Could not find the picture to export.');
    end;

    local procedure DeleteCurrentPicture()
    begin
        if Rec."User ID" <> GetCurrentUserID() then
            Error('You can only delete your own profile picture.');

        if not Confirm(DeleteImageQst) then
            exit;

        Clear(Rec.Image);
        Rec.Modify(true);
        Message('Profile picture deleted successfully.');
    end;
}
