pageextension 50105 "Sales Order Processor RC Ext" extends "Order Processor Role Center"
{
    layout
    {
        addfirst(rolecenter)
        {
            part(SaccoAdminList; "Sacco User Admin")
            {
                ApplicationArea = All;
                Caption = '🪪 Admins';
            }
            part(ChurchUserListPart; "Sacco Member List")
            {
                ApplicationArea = All;
                Caption = '👥 Murima Member List';
            }
            // part(BlurredMemberList; "Sacco Member List Blurred") // Add the blurred part here
            // {
            //     ApplicationArea = All;
            //     Caption = 'Blurred Member List';
            // }
            part(CustomerImagePart; "Customer Image Part")
            {
                ApplicationArea = All;
            }
            part(UserRegistrationPart; "Home Page Part")
            {
                ApplicationArea = All;
            }
            // part(ChurchAdminRoleCenter; "Login Action Buttons")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Church Admin Role Center';
            // }

            // Removed the ChurchLoginPart as it is now an action
        }
    }
    actions
    {
        addfirst(embedding)
        {
            action(OpenChurchLogin)
            {
                ApplicationArea = All;
                Caption = '꩜ Sacco Login';
                Image = User;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Sacco Login and Registration";
                RunPageMode = View;
            }

            // action(OpenChurchRegistration)
            // {
            //     ApplicationArea = All;
            //     Caption = '📝 Sacco Registration';
            //     Image = New;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     RunObject = Page "Sacco Login and Registration";
            //     RunPageMode = View;
            // }
        }
    }
}

page 50110 "Company Logo Part"
{
    PageType = CardPart;
    SourceTable = "Company Logo";

    layout
    {
        area(content)
        {
            field(Logo; Rec.Logo)
            {
                ApplicationArea = All;
                ShowCaption = false;

                trigger OnDrillDown()
                begin
                    UploadLogo();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get('LOGO') then begin
            Rec.Init();
            Rec."Primary Key" := 'LOGO';
            Rec.Insert();
        end;
    end;

    local procedure UploadLogo()
    var
        PictureInStream: InStream;
        FileName: Text;
    begin
        if UploadIntoStream('Select a logo to upload', '', 'All Files (*.*)|*.*', FileName, PictureInStream) then begin
            Clear(Rec.Logo);
            Rec.Logo.ImportStream(PictureInStream, FileName);
            Rec.Modify(true);
        end;
    end;
}

page 50132 "Customer Image Part"
{
    PageType = CardPart;
    Caption = 'Customer Image';
    SourceTable = "Customer";

    layout
    {
        area(content)
        {
            field(CustomerImage; Rec.Image)
            {
                ApplicationArea = All;
                Caption = 'Customer Image';
                ToolTip = 'Specifies if a customer image is available.';
                Editable = false;

                trigger OnDrillDown()
                begin
                    ShowCustomerPicture();
                end;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(UploadCustomerImage)
            {
                ApplicationArea = All;
                Caption = 'Upload Customer Image';
                Image = Import;
                // Promoted = true;
                // PromotedCategory = Process;

                trigger OnAction()
                begin
                    UploadCustomerPicture();
                end;
            }

            action(TakeCustomerPhoto)
            {
                ApplicationArea = All;
                Caption = 'Take Customer Picture';
                Image = Camera;
                // Promoted = true;
                // PromotedCategory = Process;
                Visible = CameraAvailable;

                trigger OnAction()
                begin
                    TakeCustomerPicture();
                end;
            }

            action(ExportCustomerPhoto)
            {
                ApplicationArea = All;
                Caption = 'Export Customer Picture';
                Image = Export;
                // Promoted = true;
                // PromotedCategory = Process;
                Enabled = CustomerImageExists;

                trigger OnAction()
                begin
                    ExportCustomerPicture();
                end;
            }

            action(DeleteCustomerPhoto)
            {
                ApplicationArea = All;
                Caption = 'Delete Customer Picture';
                Image = Delete;
                // Promoted = true;
                // PromotedCategory = Process;
                Enabled = CustomerImageExists;

                trigger OnAction()
                begin
                    DeleteCustomerPicture();
                end;
            }
        }
    }

    var
        Camera: Codeunit Camera;
        [InDataSet]
        CameraAvailable: Boolean;
        [InDataSet]
        CustomerImageExists: Boolean;
        OverrideImageQst: Label 'The existing picture will be replaced. Do you want to continue?';
        MustSpecifyNameErr: Label 'You must specify a customer name before you can import a picture.';
        DeleteImageQst: Label 'Are you sure you want to delete the picture?';
        MimeTypeTok: Label 'image/jpeg';

    trigger OnOpenPage()
    begin
        CameraAvailable := Camera.IsAvailable();
        if Rec.FindFirst() then;  // Load the first customer for demo purposes
    end;

    trigger OnAfterGetRecord()
    begin
        CustomerImageExists := Rec.Image.HasValue;
    end;

    local procedure ShowCustomerPicture()
    var
        TempBlob: Codeunit "Temp Blob";
        OutStream: OutStream;
        InStream: InStream;
        FileName: Text;
    begin
        if Rec.Image.HasValue then begin
            TempBlob.CreateOutStream(OutStream);
            Rec.Image.ExportStream(OutStream);
            TempBlob.CreateInStream(InStream);
            FileName := 'customer_image.jpg';
            DownloadFromStream(InStream, 'Export', '', 'All Files (*.*)|*.*', FileName);
        end
        else
            Message('No customer image available.');
    end;

    local procedure UploadCustomerPicture()
    var
        PictureInStream: InStream;
        FileName: Text;
    begin
        if Rec."No." = '' then
            Error(MustSpecifyNameErr);

        if Rec.Image.HasValue() then
            if not Confirm(OverrideImageQst) then
                exit;

        if UploadIntoStream('Select a picture to upload', '', 'All Files (*.*)|*.*', FileName, PictureInStream) then begin
            Clear(Rec.Image);
            Rec.Image.ImportStream(PictureInStream, FileName);
            Rec.Modify(true);
            Message('Customer image uploaded successfully.');
            CurrPage.Update(false);
        end;
    end;

    local procedure TakeCustomerPicture()
    var
        PictureInStream: InStream;
        PictureName: Text;
    begin
        Rec.TestField("No.");
        if Camera.GetPicture(PictureInStream, PictureName) then begin
            Clear(Rec.Image);
            Rec.Image.ImportStream(PictureInStream, PictureName);
            Rec.Modify(true);
        end;
    end;

    local procedure ExportCustomerPicture()
    var
        TempBlob: Codeunit "Temp Blob";
        OutStream: OutStream;
        InStream: InStream;
        FileName: Text;
    begin
        Rec.TestField("No.");
        Rec.TestField(Image);

        FileName := Rec."No." + '.jpg';
        TempBlob.CreateOutStream(OutStream);
        Rec.Image.ExportStream(OutStream);
        TempBlob.CreateInStream(InStream);
        DownloadFromStream(InStream, 'Export', '', 'All Files (*.*)|*.*', FileName);
    end;

    local procedure DeleteCustomerPicture()
    begin
        if not Confirm(DeleteImageQst) then
            exit;

        Clear(Rec.Image);
        Rec.Modify(true);
    end;
}

page 50111 "Sacco Login and Registrationn"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = '🕇 Murima Sacco - Login and Registration';

    layout
    {
        area(Content)
        {
            group(Overview)
            {
                Caption = '🔄 Select Action';
                field(ActionType; ActionType)
                {
                    ApplicationArea = All;
                    Caption = 'Action';
                    ToolTip = 'Select Login or Register';
                    OptionCaption = 'Login,Register';
                    trigger OnValidate()
                    begin
                        UpdateActionButton();
                    end;
                }

                field(Role; Role)
                {
                    ApplicationArea = All;
                    Caption = 'Role';
                    ToolTip = 'Select your role';
                    OptionCaption = 'Member,Admin';
                }
            }

            group(LoginSection)
            {
                Caption = '🔑 Login Here';
                Visible = (ActionType = ActionType::Login);

                field(EmailLogin; Email)
                {
                    ApplicationArea = All;
                    Caption = 'Email';
                    ToolTip = 'Enter your email address';
                    ExtendedDatatype = EMail;
                }
                field(PasswordLogin; Password)
                {
                    ApplicationArea = All;
                    Caption = 'Password';
                    ToolTip = 'Enter your password';
                    ExtendedDatatype = Masked;
                }
            }

            group(RegistrationSection)
            {
                Caption = '📝 Register Here';
                Visible = (ActionType = ActionType::Register);

                field(Username; Username) // New field for Username
                {
                    ApplicationArea = All;
                    Caption = 'Username';
                    ToolTip = 'Enter your username';
                }
                field(FirstName; FirstName)
                {
                    ApplicationArea = All;
                    Caption = 'First Name';
                    ToolTip = 'Enter your first name';
                }
                field(LastName; LastName)
                {
                    ApplicationArea = All;
                    Caption = 'Last Name';
                    ToolTip = 'Enter your last name';
                }
                field(EmailRegister; Email)
                {
                    ApplicationArea = All;
                    Caption = 'Email';
                    ToolTip = 'Enter your email address';
                    ExtendedDatatype = EMail;
                }
                field(PasswordRegister; Password)
                {
                    ApplicationArea = All;
                    Caption = 'Password';
                    ToolTip = 'Enter your password';
                    ExtendedDatatype = Masked;
                }
                field(PhoneNo; PhoneNo)
                {
                    ApplicationArea = All;
                    Caption = 'Phone Number';
                    ToolTip = 'Enter your phone number';
                }
                field(Gender; Gender)
                {
                    ApplicationArea = All;
                    Caption = 'Gender';
                    ToolTip = 'Select your gender';
                }
                field(Location; Location)
                {
                    ApplicationArea = All;
                    Caption = 'Location';
                    ToolTip = 'Enter your location';
                }
            }

            group(ActionButton)
            {
                ShowCaption = false;
                field(ActionButtonField; ActionButtonCaption)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        PerformAction();
                    end;
                }
            }
        }

        area(FactBoxes)
        {
            part(Logo; "MSacco Logo")
            {
                ApplicationArea = All;
            }
            part(ActionButtons; "Login Action Buttons")
            {
                ApplicationArea = All;
            }
            // part(UserGenderDistribution; "Church User Gender Chart")
            // {
            //     ApplicationArea = All;
            // }
        }
    }

    var
        ActionType: Option Login,Register;
        FirstName: Text[50];
        LastName: Text[50];
        Username: Text[50]; // New variable for Username
        Email: Text[80];
        Password: Text[250];
        Role: Option Member,Admin;
        ActionButtonCaption: Text;
        PhoneNo: Text[20];
        Gender: Option Male,Female,Other;
        Location: Text[100];
        UserManagement: Codeunit "Sacco User Management"; // Add this line to declare UserManagement

    trigger OnOpenPage()
    begin
        UpdateActionButton();
    end;

    procedure UpdateActionButton()
    begin
        if ActionType = ActionType::Login then
            ActionButtonCaption := '🔑 Login'
        else
            ActionButtonCaption := '📝 Register';
    end;

    procedure PerformAction()
    var
        ChurchUser: Record "Sacco User";
        UserRole: Text;
    begin
        if ActionType = ActionType::Login then begin
            // Login Logic
            if Email = '' then
                Message('Email cannot be empty.');
            if Password = '' then
                Message('Password cannot be empty.');

            ChurchUser.Reset();
            ChurchUser.SetRange("Email", Email);

            if ChurchUser.FindFirst() then begin
                if ChurchUser."Password" = Password then begin
                    UserRole := Format(ChurchUser."User Role");
                    if (UserRole = 'Admin') and (Role = Role::Admin) then begin
                        Close(); // Close the current page
                        Message('Login successful. Redirecting to the Admin Dashboard...');
                        Page.Run(Page::"Sacco Admin Dashboard");
                    end
                    else if (UserRole = 'Member') and (Role = Role::Member) then begin
                        Close(); // Close the current page
                        Message('Login successful. Redirecting to the Member Dashboard...');
                        Page.Run(Page::"Sacco Member Dashboaard");
                    end
                    else
                        Message('Unauthorized role, please try another role.');
                end
                else
                    Message('Invalid email or password. Please try again.');
            end
            else
                Message('Invalid email or password. Please try again.');
        end
        else if ActionType = ActionType::Register then begin
            // Registration Logic
            if Email = '' then
                Message('Email cannot be empty.');
            if Password = '' then
                Message('Password cannot be empty.');
            if Username = '' then
                Message('Username cannot be empty.'); // Check for empty username

            // Check for unique email
            ChurchUser.Reset();
            ChurchUser.SetRange("Email", Email);
            if ChurchUser.FindFirst() then
                Message('An account with this email already exists.');

            // Check for unique username
            ChurchUser.SetRange("User Name", Username); // Check for existing username
            if ChurchUser.FindFirst() then
                Message('An account with this username already exists.');

            // Validate password complexity
            if not IsValidPassword(Password) then
                Message('Password must contain at least one uppercase letter and one number.');

            ChurchUser.Init();
            // Replace the GUID assignment with a generated unique ID
            ChurchUser."User ID" := UserManagement.GenerateUniqueUserID();
            ChurchUser."First Name" := FirstName;
            ChurchUser."Last Name" := LastName;
            ChurchUser."Email" := Email;
            ChurchUser."Password" := Password;
            ChurchUser."User Role" := Role;
            ChurchUser.Status := ChurchUser.Status::Active;
            ChurchUser."Phone No." := PhoneNo;
            ChurchUser.Gender := Gender;
            ChurchUser.Location := Location;
            ChurchUser."User Name" := Username; // Save the username

            ChurchUser.Insert();
            Message('Registration successful.');
            ClearRegistrationFields();
        end;
    end;

    procedure GetActionType(): Option Login,Register; // Returns the current ActionType
    begin
        exit(ActionType);
    end;

    local procedure ClearRegistrationFields()
    begin
        Clear(FirstName);
        Clear(LastName);
        Clear(Email);
        Clear(Password);
        Clear(PhoneNo);
        Clear(Gender);
        Clear(Location);
        Clear(Username); // Clear the username field
    end;

    local procedure IsValidPassword(Password: Text): Boolean
    var
        HasUppercase: Boolean;
        HasNumber: Boolean;
        i: Integer;
    begin
        HasUppercase := false;
        HasNumber := false;

        for i := 1 to StrLen(Password) do begin
            if Password[i] in ['A' .. 'Z'] then
                HasUppercase := true;
            if Password[i] in ['0' .. '9'] then
                HasNumber := true;
        end;

        exit(HasUppercase and HasNumber); // Return true if both conditions are met
    end;
}


page 50112 "Home Page Part"
{
    PageType = CardPart;
    Caption = 'Sacco Login And Registration';

    layout
    {
        area(content)
        {
            group(HomePageGroup)
            {
                ShowCaption = false;

                field(OpenloginandRegistrationPage; 'Open Login And Register page')
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    Style = StrongAccent;
                    StyleExpr = TRUE;

                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"Sacco Login and Registration");
                    end;
                }
            }
        }
    }
}