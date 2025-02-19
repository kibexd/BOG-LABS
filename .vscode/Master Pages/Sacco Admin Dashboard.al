page 50126 "Sacco Admin Dashboard"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = '👑 Admin Dashboard';

    layout
    {
        area(Content)
        {
            group(WelcomeBanner)
            {
                ShowCaption = false;
                field(AdminWelcome; GetAdminWelcome())
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                    StyleExpr = 'StrongAccent';
                }
            }

            group(Statistics)
            {
                Caption = '📊 System Overview';

                group(MemberStats)
                {
                    Caption = 'Member Statistics';
                    field(TotalMembers; GetTotalMembers())
                    {
                        ApplicationArea = All;
                        Caption = 'Total Members';
                        StyleExpr = 'Strong';
                        Editable = false;
                    }
                    field(ActiveLoans; GetActiveLoanCount())
                    {
                        ApplicationArea = All;
                        Caption = 'Active Loans';
                        StyleExpr = 'Favorable';
                        Editable = false;
                    }
                    field(PendingLoans; GetPendingLoanCount())
                    {
                        ApplicationArea = All;
                        Caption = 'Pending Loans';
                        StyleExpr = 'Attention';
                        Editable = false;
                    }
                }

                group(FinancialStats)
                {
                    Caption = 'Financial Overview';
                    field(TotalLoanAmount; GetTotalLoanAmount())
                    {
                        ApplicationArea = All;
                        Caption = 'Total Loan Amount';
                        StyleExpr = 'Strong';
                        Editable = false;
                    }
                    field(TotalRepayments; GetTotalRepayments())
                    {
                        ApplicationArea = All;
                        Caption = 'Total Repayments';
                        StyleExpr = 'Favorable';
                        Editable = false;
                    }
                    field(OutstandingAmount; GetOutstandingAmount())
                    {
                        ApplicationArea = All;
                        Caption = 'Outstanding Amount';
                        StyleExpr = 'Ambiguous';
                        Editable = false;
                    }
                }
            }

            group(PendingApprovals)
            {
                Caption = '⏳ Pending Loan Approvals';

                part(PendingLoansList; "Pending Loans List Part")
                {
                    ApplicationArea = All;
                }
            }

            group(ActiveLoanss)
            {
                Caption = 'Active Loans';

                part(ActiveLoansList; "Active Loans List Part")
                {
                    ApplicationArea = All;
                }
            }

            group(MemberManagement)
            {
                Caption = '👥 Member Management';

                part(MembersList; "Admin Members List Part")
                {
                    ApplicationArea = All;
                    Caption = 'Manage Members';
                }

                // field(UserStatus; UserStatus)
                // {
                //     ApplicationArea = All;
                //     Caption = 'User Status';
                //     ToolTip = 'Current status of the user';
                //     Editable = true;
                //     trigger OnValidate()
                //     begin
                //         UpdateUserStatus();
                //     end;
                // }
            }

            group(RecentActivities)
            {
                Caption = '📅 Recent Activities';

                part(RecentActivityList; "Recent Activities List Part")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ApproveLoan)
            {
                ApplicationArea = All;
                Caption = '✓ Approve Selected Loan';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ApprovePendingLoan();
                end;
            }

            action(RepayLoan)
            {
                ApplicationArea = All;
                Caption = '💳 Repay Loan';
                Image = Payment;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    LoanRepaymentJournal: Record "Loan Repayment Journal";
                    IsLoanSelected: Action;
                    LoanRepaymentJournalPage: Page "Admin Loan List";
                begin
                    IsLoanSelected := LoanRepaymentJournalPage.RUNMODAL;

                    if IsLoanSelected = ACTION::LookupOK then begin
                        LoanRepaymentJournal.Status := LoanRepaymentJournal.Status::Repayment;
                        LoanRepaymentJournal.Modify();
                        Message('Loan repayment processed successfully.');
                        LoadActiveLoans();
                    end else
                        Error('No loan was selected for repayment.');
                end;
            }

            action(ViewAllMembers)
            {
                ApplicationArea = All;
                Caption = '👥 View All Members';
                Image = List;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Sacco Member List";
            }

            action(ViewAllLoans)
            {
                ApplicationArea = All;
                Caption = '📋 View All Loans';
                Image = List;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Admin Loan List";
            }

            action(ViewPayments)
            {
                ApplicationArea = All;
                Caption = '💰 View All Payments';
                Image = Payment;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Admin Payment List";
            }

            action(Reports)
            {
                ApplicationArea = All;
                Caption = '📊 Generate Reports';
                Image = Report;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ShowReportsDialog();
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
                    if Confirm('Are you sure you want to logout?') then begin
                        CurrPage.Close();
                        Page.Run(Page::"Sacco Login and Registration");
                    end;
                end;
            }
        }

        area(Navigation)
        {
            action(Settings)
            {
                ApplicationArea = All;
                Caption = '⚙️ System Settings';
                Image = Setup;
                RunObject = Page "Sacco System Setup";
            }
        }
    }

    var
        [InDataSet]
        TotalMembersCount: Integer;
        ActiveLoansCount: Integer;
        PendingLoansCount: Integer;
        TotalLoanAmt: Decimal;
        TotalRepaymentsAmt: Decimal;
        OutstandingAmt: Decimal;

    trigger OnOpenPage()
    begin
        LoadDashboardStatistics();
    end;

    local procedure LoadDashboardStatistics()
    begin
        // Implementation will be added
        RefreshDashboard();
    end;

    local procedure RefreshDashboard()
    begin
        CurrPage.Update(false);
    end;

    local procedure GetAdminWelcome(): Text
    var
        CurrentTime: Time;
        Hour: Integer;
        TimeString: Text[8];
        Greeting: Text;
    begin
        CurrentTime := Time;
        TimeString := Format(CurrentTime, 0, '<Hours24>');
        Evaluate(Hour, CopyStr(TimeString, 1, 2));

        case true of
            Hour < 12:
                Greeting := '🌅 Good Morning';
            Hour < 17:
                Greeting := '☀️ Good Afternoon';
            else
                Greeting := '🌙 Good Evening';
        end;

        exit(StrSubstNo('%1, Admin!', Greeting));
    end;

    local procedure GetTotalMembers(): Integer
    var
        SaccoUser: Record "Sacco User";
    begin
        SaccoUser.Reset();
        SaccoUser.SetRange("User Role", SaccoUser."User Role"::Member);
        exit(SaccoUser.Count);
    end;

    local procedure GetActiveLoanCount(): Integer
    var
        PostedLoanLedger: Record "Posted Loan Repayments Ledger";
    begin
        PostedLoanLedger.Reset();
        PostedLoanLedger.SetRange(Status, PostedLoanLedger.Status::Active);
        exit(PostedLoanLedger.Count);
    end;

    local procedure GetPendingLoanCount(): Integer
    var
        LoanRepaymentJournal: Record "Loan Repayment Journal";
    begin
        LoanRepaymentJournal.Reset();
        LoanRepaymentJournal.SetRange(Status, LoanRepaymentJournal.Status::Pending);
        exit(LoanRepaymentJournal.Count);
    end;

    local procedure GetTotalLoanAmount(): Decimal
    var
        PostedLoanLedger: Record "Posted Loan Repayments Ledger";
    begin
        PostedLoanLedger.Reset();
        PostedLoanLedger.SetRange("Entry Type", PostedLoanLedger."Entry Type"::Loan);
        if PostedLoanLedger.FindSet() then begin
            PostedLoanLedger.CalcSums(Amount);
            exit(PostedLoanLedger.Amount);
        end;
        exit(0);
    end;

    local procedure GetTotalRepayments(): Decimal
    var
        PostedLoanLedger: Record "Posted Loan Repayments Ledger";
    begin
        PostedLoanLedger.Reset();
        PostedLoanLedger.SetRange("Entry Type", PostedLoanLedger."Entry Type"::Repayment);
        if PostedLoanLedger.FindSet() then begin
            PostedLoanLedger.CalcSums(Amount);
            exit(Abs(PostedLoanLedger.Amount));
        end;
        exit(0);
    end;

    local procedure GetOutstandingAmount(): Decimal
    begin
        exit(GetTotalLoanAmount() - GetTotalRepayments());
    end;

    local procedure ApprovePendingLoan()
    var
        LoanRepaymentJournal: Record "Loan Repayment Journal";
        LoanPosting: Codeunit "Loan Repayment Posting";
    begin
        CurrPage.PendingLoansList.Page.GetRecord(LoanRepaymentJournal);
        if LoanRepaymentJournal.Status = LoanRepaymentJournal.Status::Pending then begin
            if Confirm('Are you sure you want to approve this loan application?') then begin
                LoanRepaymentJournal.Status := LoanRepaymentJournal.Status::Approved;
                LoanRepaymentJournal.Modify();
                LoanPosting.PostLoanApplication(LoanRepaymentJournal);
                Message('Loan application approved successfully.');
                CurrPage.Update(false);
            end;
        end else
            Error('Only pending loans can be approved.');
    end;

    local procedure ShowReportsDialog()
    var
        ReportSelection: Integer;
    begin
        ReportSelection := Dialog.StrMenu('Member List,Loan Summary,Payment History,Outstanding Loans', 1, 'Select Report');
        case ReportSelection of
            1:
                Report.Run(Report::"Member List Report");
            2:
                Report.Run(Report::"Loan Summary Report");
            3:
                Report.Run(Report::"Payment History Report");
            4:
                Report.Run(Report::"Outstanding Loans Report");
        end;
    end;

    local procedure LoadActiveLoans()
    var
        LoanRepaymentJournal: Record "Loan Repayment Journal";
    begin
        LoanRepaymentJournal.Reset();
        LoanRepaymentJournal.SetRange(Status, LoanRepaymentJournal.Status::Approved); // Only approved loans
        // Load active loans logic...
    end;
}
