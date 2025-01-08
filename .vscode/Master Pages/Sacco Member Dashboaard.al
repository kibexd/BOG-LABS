page 50121 "Sacco Member Dashboaard"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Sacco User";
    Caption = '👤 Member Dashboard';

    layout
    {
        area(Content)
        {
            group(WelcomeBanner)
            {
                ShowCaption = false;

                field(WelcomeMessage; GetWelcomeMessage())
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                    StyleExpr = 'StrongAccent';
                }
            }

            group(MemberInfo)
            {
                Caption = 'Member Information';
                field(UserID; Rec."User ID")
                {
                    ApplicationArea = All;
                    Caption = 'Member ID';
                    Editable = false;
                }
                field(UserName; StrSubstNo('%1 %2', Rec."First Name", Rec."Last Name"))
                {
                    ApplicationArea = All;
                    Caption = 'Member Name';
                    Editable = false;
                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = All;
                    Caption = 'Email';
                    Editable = false;
                }
            }

            group(LoanApplication)
            {
                Caption = 'Loan Application';

                field(LoanAmount; LoanAmount)
                {
                    ApplicationArea = All;
                    Caption = 'Loan Amount';
                    MinValue = 1000;
                    MaxValue = 1000000;

                    trigger OnValidate()
                    begin
                        ValidateLoanAmount();
                    end;
                }
                field(LoanPurpose; LoanPurpose)
                {
                    ApplicationArea = All;
                    Caption = 'Loan Purpose';
                    NotBlank = true;
                }
                field(RepaymentPeriod; RepaymentPeriodMonths)
                {
                    ApplicationArea = All;
                    Caption = 'Repayment Period (Months)';
                    MinValue = 1;
                    MaxValue = 48;

                    trigger OnValidate()
                    begin
                        CalculateRepaymentAmount();
                    end;
                }
                field(MonthlyRepayment; MonthlyRepaymentAmount)
                {
                    ApplicationArea = All;
                    Caption = 'Monthly Repayment Amount';
                    Editable = false;
                }
            }

            group(Statistics)
            {
                Caption = 'Loan Statistics';
                field(TotalActiveLoans; TotalActiveLoans)
                {
                    ApplicationArea = All;
                    Caption = 'Total Active Loans';
                    Editable = false;
                }
                field(TotalRepayments; TotalRepayments)
                {
                    ApplicationArea = All;
                    Caption = 'Total Repayments Made';
                    Editable = false;
                }
            }

            group(ActiveLoansGroup)
            {
                Caption = 'Active Loans';
                field(ActiveLoanCount; ActiveLoanCount)
                {
                    ApplicationArea = All;
                    Caption = 'Number of Active Loans';
                    Editable = false;
                }

                part(ActiveLoansList; "Active Loans List Part")
                {
                    ApplicationArea = All;
                    SubPageLink = "Member ID" = field("User ID");
                    UpdatePropagation = Both;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ApplyLoan)
            {
                ApplicationArea = All;
                Caption = '📝 Apply for Loan';
                Image = NewDocument;
                Promoted = true;
                PromotedCategory = Process;
                Enabled = CanApplyLoan;

                trigger OnAction()
                begin
                    if not ValidateBeforePosting() then
                        exit;
                    CreateLoanApplication();
                end;
            }
            action(ViewLoans)
            {
                ApplicationArea = All;
                Caption = '📋 View My Loans';
                Image = List;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Member Loan History";
                RunPageLink = "Member ID" = field("User ID");
            }
            action(ViewPayments)
            {
                ApplicationArea = All;
                Caption = '💰 Payment History';
                Image = Payment;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Member Payment History";
                RunPageLink = "Member ID" = field("User ID");
            }
            action(RepayActiveLoan)
            {
                ApplicationArea = All;
                Caption = '💳 Repay Active Loan';
                Image = Payment;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    LoanRepaymentJournal: Record "Loan Repayment Journal";
                    IsLoanSelected: Action;
                    LoanRepaymentJournalPage: Page "Admin Loan List";
                begin
                    // Open the Loan Repayment Journal List for the user to select a record
                    IsLoanSelected := LoanRepaymentJournalPage.RUNMODAL;

                    if IsLoanSelected = ACTION::LookupOK then begin
                        LoanRepaymentJournal.Status := LoanRepaymentJournal.Status::Repayment; // Update status
                        LoanRepaymentJournal.Modify();

                        Message('Loan repayment processed successfully.');

                        // Reload the active loans after modification
                        LoadActiveLoans();
                    end else
                        Message('No loan was selected for repayment.');
                end;

            }
            action(Logout)
            {
                ApplicationArea = All;
                Caption = '🚪 Logout';
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    if Confirm(LogoutQst) then begin
                        CurrPage.Close();
                        Page.Run(PAGE::"Sacco Login and Registration");
                    end;
                end;
            }
            action(TestAction)
            {
                ApplicationArea = All;
                Caption = 'Test Action';
                trigger OnAction()
                begin
                    Message('Test action triggered successfully.');
                end;
            }
        }
    }

    var
        LoanAmount: Decimal;
        LoanPurpose: Text[250];
        RepaymentPeriodMonths: Integer;
        MonthlyRepaymentAmount: Decimal;
        TotalActiveLoans: Decimal;
        TotalRepayments: Decimal;
        CanApplyLoan: Boolean;
        ActiveLoanCount: Integer;
        CurrentJournalBatchName: Code[20];
        LogoutQst: Label 'Are you sure you want to logout?';
        MinLoanAmountMsg: Label 'Minimum loan amount is %1', Comment = '%1 = Minimum loan amount';
        MaxLoanAmountMsg: Label 'Maximum loan amount is %1', Comment = '%1 = Maximum loan amount';
        LoanConfirmQst: Label 'Are you sure you want to apply for a loan with the following details?\Amount: %1\Purpose: %2\Repayment Period: %3 months\Monthly Repayment: %4',
            Comment = '%1 = Loan amount, %2 = Loan purpose, %3 = Repayment period, %4 = Monthly repayment';
        GlobalVar: Codeunit "Sacco Global Variables";

    trigger OnOpenPage()
    var
        SaccoUserMgt: Codeunit "Sacco User Management";
        SaccoUser: Record "Sacco User";
        UserEmail: Text[80];
    begin
        UserEmail := GlobalVar.GetUserEmail();
        Message('Retrieved Email: ' + UserEmail);

        if not SaccoUserMgt.GetUserByEmail(UserEmail, SaccoUser) then
            Message('Unable to retrieve user information. Please log in again.');

        if SaccoUser.Status <> SaccoUser.Status::Active then
            Message('Your account is not active. Please contact administrator.');

        Rec := SaccoUser;
        CurrentJournalBatchName := 'DEFAULT';
        CanApplyLoan := not HasPendingLoan();
        LoadUserStatistics();
        LoadActiveLoans();
    end;

    trigger OnAfterGetRecord()
    begin
        CanApplyLoan := not HasPendingLoan();
    end;

    local procedure ValidateLoanAmount()
    begin
        if LoanAmount < 1000 then
            Message(MinLoanAmountMsg, 1000);
        if LoanAmount > 1000000 then
            Message(MaxLoanAmountMsg, 1000000);

        CalculateRepaymentAmount();
    end;

    local procedure CalculateRepaymentAmount()
    var
        InterestRate: Decimal;
    begin
        if (LoanAmount <= 0) or (RepaymentPeriodMonths <= 0) then
            exit;

        InterestRate := 0.15;
        MonthlyRepaymentAmount := (LoanAmount * (1 + (InterestRate * RepaymentPeriodMonths / 12))) / RepaymentPeriodMonths;
    end;

    local procedure LoadUserStatistics()
    var
        PostedLoanLedger: Record "Posted Loan Repayments Ledger";
    begin
        Clear(TotalActiveLoans);
        Clear(TotalRepayments);

        PostedLoanLedger.Reset();
        PostedLoanLedger.SetRange("Member ID", Rec."User ID");
        PostedLoanLedger.SetRange("Entry Type", PostedLoanLedger."Entry Type"::Loan);
        PostedLoanLedger.SetRange(Status, PostedLoanLedger.Status::Active);
        if PostedLoanLedger.FindSet() then begin
            PostedLoanLedger.CalcSums(Amount);
            TotalActiveLoans := PostedLoanLedger.Amount;
        end;

        PostedLoanLedger.Reset();
        PostedLoanLedger.SetRange("Member ID", Rec."User ID");
        PostedLoanLedger.SetRange("Entry Type", PostedLoanLedger."Entry Type"::Repayment);
        if PostedLoanLedger.FindSet() then begin
            PostedLoanLedger.CalcSums(Amount);
            TotalRepayments := Abs(PostedLoanLedger.Amount);
        end;

        CurrPage.Update(false);
    end;

    local procedure LoadActiveLoans()
    var
        PostedLoanLedger: Record "Posted Loan Repayments Ledger";
    begin
        PostedLoanLedger.Reset();
        PostedLoanLedger.SetRange("Member ID", Rec."User ID");
        PostedLoanLedger.SetRange(Status, PostedLoanLedger.Status::Active);
        ActiveLoanCount := PostedLoanLedger.Count;
    end;

    local procedure ValidateBeforePosting(): Boolean
    begin
        if LoanAmount <= 0 then
            Message('Loan amount must be greater than zero');

        if LoanAmount < 1000 then
            Message(MinLoanAmountMsg, 1000);

        if LoanAmount > 1000000 then
            Message(MaxLoanAmountMsg, 1000000);

        if LoanPurpose = '' then
            Message('Please specify loan purpose');

        if RepaymentPeriodMonths <= 0 then
            Message('Please specify valid repayment period');

        if HasPendingLoan() then
            Message('You have pending loan applications');

        exit(true);
    end;

    local procedure CreateLoanApplication()
    var
        LoanRepaymentJournal: Record "Loan Repayment Journal";
        LoanPosting: Codeunit "Loan Repayment Posting";
        NewLoanID: Code[20];
    begin
        if not Confirm(LoanConfirmQst, false, LoanAmount, LoanPurpose, RepaymentPeriodMonths, MonthlyRepaymentAmount) then
            exit;

        NewLoanID := LoanPosting.GenerateUniqueLoanID();

        LoanRepaymentJournal.Init();
        LoanRepaymentJournal."Journal Template Name" := 'LOAN';
        LoanRepaymentJournal."Journal Batch Name" := CurrentJournalBatchName;
        LoanRepaymentJournal."Line No." := GetNextLineNo();
        LoanRepaymentJournal."Loan ID" := NewLoanID;
        LoanRepaymentJournal."Member ID" := Rec."User ID";
        LoanRepaymentJournal."Member Name" := StrSubstNo('%1 %2', Rec."First Name", Rec."Last Name");
        LoanRepaymentJournal."Posting Date" := Today;
        LoanRepaymentJournal."Document Type" := LoanRepaymentJournal."Document Type"::Application;
        LoanRepaymentJournal.Amount := LoanAmount;
        LoanRepaymentJournal."Loan Purpose" := LoanPurpose;
        LoanRepaymentJournal."Repayment Period" := RepaymentPeriodMonths;
        LoanRepaymentJournal."Monthly Repayment Amount" := MonthlyRepaymentAmount;
        LoanRepaymentJournal.Status := LoanRepaymentJournal.Status::Pending;

        if LoanRepaymentJournal.Insert(true) then begin
            Message('Loan application submitted successfully. Your Loan ID is: %1', NewLoanID);
            ClearLoanFields();
            LoadUserStatistics();
            LoadActiveLoans();
            CanApplyLoan := false;
        end;
    end;

    local procedure ClearLoanFields()
    begin
        Clear(LoanAmount);
        Clear(LoanPurpose);
        Clear(RepaymentPeriodMonths);
        Clear(MonthlyRepaymentAmount);
        CurrPage.Update(false);
    end;

    local procedure GetNextLineNo(): Integer
    var
        LoanRepaymentJournal: Record "Loan Repayment Journal";
    begin
        LoanRepaymentJournal.Reset();
        LoanRepaymentJournal.SetRange("Journal Template Name", 'LOAN');
        LoanRepaymentJournal.SetRange("Journal Batch Name", CurrentJournalBatchName);
        if LoanRepaymentJournal.FindLast() then
            exit(LoanRepaymentJournal."Line No." + 10000);
        exit(10000);
    end;

    local procedure HasPendingLoan(): Boolean
    var
        LoanRepaymentJournal: Record "Loan Repayment Journal";
    begin
        LoanRepaymentJournal.Reset();
        LoanRepaymentJournal.SetRange("Member ID", Rec."User ID");
        LoanRepaymentJournal.SetRange(Status, LoanRepaymentJournal.Status::Pending);
        exit(not LoanRepaymentJournal.IsEmpty);
    end;

    local procedure GetWelcomeMessage(): Text
    var
        CurrentTime: Time;
        Hour: Integer;
        TimeString: Text[8];
        Greeting: Text;
    begin
        CurrentTime := Time();
        TimeString := Format(CurrentTime, 0, 0);
        Evaluate(Hour, CopyStr(TimeString, 1, 2));

        case true of
            Hour < 12:
                Greeting := '🌅 Good Morning';
            Hour < 17:
                Greeting := '☀️ Good Afternoon';
            else
                Greeting := '🌙 Good Evening';
        end;

        exit(StrSubstNo('%1, %2 %3 (Member Account)',
            Greeting,
            Rec."First Name",
            Rec."Last Name"));
    end;
}