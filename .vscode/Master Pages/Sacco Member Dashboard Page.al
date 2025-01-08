page 50113 "Sacco Member Dashboardd"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = '👤 Member Dashboard';

    layout
    {
        area(Content)
        {
            group(WelcomeMessage)
            {
                ShowCaption = false;
                field(WelcomeText; WelcomeMessage)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                    StyleExpr = 'Strong';
                }
            }

            group(MemberInfo)
            {
                Caption = '📋 Member Information';

                field(MemberID; MemberID)
                {
                    ApplicationArea = All;
                    Caption = 'Member ID';
                    Editable = false;
                }
                field(Username; Username)
                {
                    ApplicationArea = All;
                    Caption = 'Username';
                    Editable = false;
                }
                field(CurrentSavings; CurrentSavings)
                {
                    ApplicationArea = All;
                    Caption = 'Current Savings';
                    Editable = false;
                }
                field(LoanBalance; LoanBalance)
                {
                    ApplicationArea = All;
                    Caption = 'Current Loan Balance';
                    Editable = false;
                }
                field(NextPaymentDate; NextPaymentDate)
                {
                    ApplicationArea = All;
                    Caption = 'Next Payment Due';
                    Editable = false;
                }
            }

            group(ActionSelection)
            {
                Caption = '🔄 Select Action';
                field(SelectedAction; SelectedAction)
                {
                    ApplicationArea = All;
                    Caption = 'Choose Action';
                    OptionCaption = 'View Details,Apply for Loan,Make Payment';
                    trigger OnValidate()
                    begin
                        UpdateVisibility();
                    end;
                }
            }

            group(LoanApplication)
            {
                Caption = '💰 Loan Application';
                Visible = IsLoanApplicationVisible;

                field(LoanAmount; LoanAmount)
                {
                    ApplicationArea = All;
                    Caption = 'Loan Amount';
                    trigger OnValidate()
                    begin
                        CalculateLoanDetails();
                    end;
                }
                field(LoanDuration; LoanDuration)
                {
                    ApplicationArea = All;
                    Caption = 'Loan Duration';
                    OptionCaption = '6 Months,8 Months,12 Months,24 Months';
                    trigger OnValidate()
                    begin
                        CalculateLoanDetails();
                    end;
                }
                field(StartDate; StartDate)
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    trigger OnValidate()
                    begin
                        CalculateLoanDetails();
                    end;
                }
                field(InterestRate; InterestRate)
                {
                    ApplicationArea = All;
                    Caption = 'Monthly Interest Rate (%)';
                    Editable = false;
                }
                field(MonthlyPayment; MonthlyPayment)
                {
                    ApplicationArea = All;
                    Caption = 'Monthly Payment';
                    Editable = false;
                }
                field(TotalInterest; TotalInterest)
                {
                    ApplicationArea = All;
                    Caption = 'Total Interest';
                    Editable = false;
                }
                field(TotalAmount; TotalAmount)
                {
                    ApplicationArea = All;
                    Caption = 'Total Amount to Repay';
                    Editable = false;
                }
                field(EndDate; EndDate)
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    Editable = false;
                }
            }

            group(PaymentSection)
            {
                Caption = '💳 Make Payment';
                Visible = IsPaymentVisible;

                field(PaymentAmount; PaymentAmount)
                {
                    ApplicationArea = All;
                    Caption = 'Payment Amount';
                }
                field(PaymentDate; PaymentDate)
                {
                    ApplicationArea = All;
                    Caption = 'Payment Date';
                }
                field(PaymentMethod; PaymentMethod)
                {
                    ApplicationArea = All;
                    Caption = 'Payment Method';
                    OptionCaption = 'M-Pesa,Bank Transfer,Cash';
                }
            }

            group(ActionButtons)
            {
                ShowCaption = false;

                field(SubmitAction; SubmitActionCaption)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    Editable = false;
                    Style = Favorable;

                    trigger OnDrillDown()
                    begin
                        PerformSelectedAction();
                    end;
                }
            }
        }

        area(FactBoxes)
        {
            part(UserProfile; "User Profile Part")  // Assuming this part exists
            {
                ApplicationArea = All;
                Caption = '🖼️ Profile Picture';
            }
            part(LoanHistory; "Member Loan History")
            {
                ApplicationArea = All;
                Caption = '📊 Loan History';
            }
            part(PaymentHistory; "Member Payment History")
            {
                ApplicationArea = All;
                Caption = '📑 Payment History';
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ViewStatement)
            {
                ApplicationArea = All;
                Caption = 'View Statement';
                Image = Report;
                Promoted = true;

                trigger OnAction()
                begin
                    Message('Statement feature coming soon.');
                end;
            }

            action(MakeLoanRepayment)
            {
                ApplicationArea = All;
                Caption = 'Make Loan Repayment';
                Image = BankAccount;
                Promoted = true;

                trigger OnAction()
                var
                    RepaymentAmount: Decimal;
                    UserInput: Boolean;
                    LoanDetails: Record "Loan Repayment Journal"; // Assuming this record holds loan details
                    PaymentHistory: Record "Member Payment History"; // Assuming this record holds payment history
                begin
                    // Check if there is an existing loan
                    if LoanDetails.Get(MemberID) then begin // Assuming MemberID is used to find the loan
                        // Display loan details and amount due
                        Message('Your current loan balance is %1 Ksh. Please enter the repayment amount.', LoanDetails."Loan Amount");

                        // Ask for repayment amount
                        UserInput := Dialog.Confirm('Enter Repayment Amount:', true, RepaymentAmount);

                        if UserInput then begin
                            // Capture the repayment amount and post it
                            PostLoanRepayment(RepaymentAmount); // Call the posting procedure

                            // Save payment details to Member Payment History
                            PaymentHistory."Member ID" := MemberID;
                            PaymentHistory."Payment Amount" := RepaymentAmount;
                            PaymentHistory."Payment Date" := Today; // Assuming today's date for the payment
                            PaymentHistory.Insert(); // Insert into Member Payment History

                            Message('Repayment of %1 Ksh posted successfully!', RepaymentAmount);
                            CurrPage.Update(); // Refresh the page to update the loan balance
                        end
                        else
                            Message('Loan repayment canceled.');
                    end
                    else
                        Message('No existing loan found for this member.');

                    // Close the action/page after processing
                    CurrPage.Close(); // Close the current page
                end;
            }

            action(Logout)
            {
                ApplicationArea = All;
                Caption = 'Logout';
                Image = Close;
                Promoted = true;

                trigger OnAction()
                begin
                    CurrPage.Close();
                end;
            }

            action(ApplyForLoan)
            {
                ApplicationArea = All;
                Caption = 'Apply for Loan';
                Image = BankAccount;
                Promoted = true;

                trigger OnAction()
                var
                    LoanDetails: Record "Loan Repayment Journal"; // Assuming this record holds loan details
                begin
                    if not ValidateLoanApplication() then
                        exit;

                    // Logic to apply for the loan
                    PostLoanApplication(); // Call the posting procedure

                    // Save loan details to Member Loan History
                    LoanDetails."Member ID" := MemberID;
                    LoanDetails."Loan Amount" := LoanAmount;
                    LoanDetails."Loan Duration" := LoanDuration;
                    LoanDetails."Start Date" := StartDate;
                    LoanDetails."End Date" := EndDate;
                    LoanDetails."Monthly Payment" := MonthlyPayment;
                    LoanDetails."Total Interest" := TotalInterest;
                    LoanDetails."Total Amount" := TotalAmount;
                    LoanDetails.Insert(); // Insert into Loan Repayment Journal

                    Message('Loan application submitted for %1 Ksh.', LoanAmount);

                    // Optionally, close the page after applying
                    CurrPage.Close();
                end;
            }
        }
    }

    var
        MemberID: Code[20];
        Username: Text[50];
        CurrentSavings: Decimal;
        LoanBalance: Decimal;
        NextPaymentDate: Date;
        SelectedAction: Option "View Details","Apply for Loan","Make Payment";
        LoanAmount: Decimal;
        LoanDuration: Option "6","8","12","24";
        StartDate: Date;
        EndDate: Date;
        InterestRate: Decimal;
        MonthlyPayment: Decimal;
        TotalInterest: Decimal;
        TotalAmount: Decimal;
        PaymentAmount: Decimal;
        PaymentDate: Date;
        PaymentMethod: Option "M-Pesa","Bank Transfer","Cash";
        IsLoanApplicationVisible: Boolean;
        IsPaymentVisible: Boolean;
        SubmitActionCaption: Text;
        SaccoUser: Record "Sacco User"; // Sacco User Record
        WelcomeMessage: Text;

    trigger OnOpenPage()
    begin
        LoadMemberInfo();
        UpdateVisibility();
        InterestRate := 2; // Set default interest rate to 2%
        StartDate := Today;
        PaymentDate := Today;

        // Set welcome message
        WelcomeMessage := GetWelcomeMessage();
    end;

    local procedure GetWelcomeMessage(): Text
    var
        CurrentTime: Time;
        Hour: Integer;
        TimeString: Text[8];
    begin
        CurrentTime := Time(); // Get the current time
        TimeString := FORMAT(CurrentTime, 0, 0); // Format the time to a string (HH:MM:SS)

        // Extract the hour part from the string and convert to Integer
        EVALUATE(Hour, COPYSTR(TimeString, 1, 2)); // Use EVALUATE to convert the substring to an integer

        case true of
            (Hour < 12):
                exit(StrSubstNo('🌅 Good Morning, %1!', Username));
            (Hour < 17):
                exit(StrSubstNo('☀️ Good Afternoon, %1!', Username));
            else
                exit(StrSubstNo('🌙 Good Evening, %1!', Username));
        end;
    end;

    local procedure LoadMemberInfo()
    begin
        // Load current user's information
        if SaccoUser.Get(UserId) then begin
            MemberID := SaccoUser."User ID";
            Username := SaccoUser."User Name";
            LoanBalance := SaccoUser."Loan Balance"; // Assuming Loan Balance is in Sacco User Table
            NextPaymentDate := SaccoUser."Next Payment Date"; // Assuming Next Payment Date exists
            // Load other member details here
        end;
    end;

    local procedure UpdateVisibility()
    begin
        // Determine visibility of Loan Application and Payment sections based on selected action
        IsLoanApplicationVisible := (SelectedAction = SelectedAction::"Apply for Loan");
        IsPaymentVisible := (SelectedAction = SelectedAction::"Make Payment");

        // Update the Submit Action Caption based on the selected action
        case SelectedAction of
            SelectedAction::"Apply for Loan":
                begin
                    SubmitActionCaption := '📝 Submit Loan Application';
                    // Optionally reset the loan fields to clear previous values
                    ResetLoanFields();
                end;

            SelectedAction::"Make Payment":
                begin
                    SubmitActionCaption := '💰 Submit Payment';
                    // Optionally reset payment fields to clear previous values
                    ResetPaymentFields();
                end;

            else
                SubmitActionCaption := '';
        end;
    end;

    /// Procedure to reset loan fields
    local procedure ResetLoanFields()
    begin
        LoanAmount := 0; // Reset loan amount
        LoanDuration := LoanDuration::"6"; // Reset loan duration to a valid default option
        StartDate := 0D; // Reset start date
        MonthlyPayment := 0; // Reset monthly payment
        TotalInterest := 0; // Reset total interest
        TotalAmount := 0; // Reset total amount to repay
        EndDate := 0D; // Reset end date
    end;

    // Procedure to reset payment fields
    local procedure ResetPaymentFields()
    begin
        PaymentAmount := 0; // Reset payment amount
        PaymentDate := 0D; // Reset payment date
        PaymentMethod := PaymentMethod::"M-Pesa"; // Reset payment method to a valid default option
                                                  // Clear other related fields as necessary
    end;



    local procedure CalculateLoanDetails()
    var
        DurationMonths: Integer;
    begin
        if (LoanAmount <= 0) then
            exit;

        case LoanDuration of
            LoanDuration::"6":
                DurationMonths := 6;
            LoanDuration::"8":
                DurationMonths := 8;
            LoanDuration::"12":
                DurationMonths := 12;
            LoanDuration::"24":
                DurationMonths := 24;
        end;

        // Calculate loan details
        TotalInterest := LoanAmount * (InterestRate / 100) * DurationMonths;
        TotalAmount := LoanAmount + TotalInterest;
        MonthlyPayment := TotalAmount / DurationMonths;
        EndDate := CalcDate(StrSubstNo('<%1M>', DurationMonths), StartDate);
    end;

    local procedure PerformSelectedAction()
    begin
        case SelectedAction of
            SelectedAction::"Apply for Loan":
                begin
                    if LoanAmount <= 0 then begin
                        Message('Please enter a valid loan amount.');
                        exit;
                    end;

                    // Logic to apply for the loan
                    PostLoanApplication();
                    Message('Loan application submitted for %1 Ksh.', LoanAmount);
                end;

            SelectedAction::"Make Payment":
                begin
                    if PaymentAmount <= 0 then begin
                        Message('Please enter a valid payment amount.');
                        exit;
                    end;

                    // Logic to make the payment
                    PostPayment(PaymentAmount);
                    Message('Payment of %1 Ksh received successfully!', PaymentAmount);
                end;

            else
                Message('Please select a valid action.');
        end;
    end;

    local procedure PostLoanApplication()
    var
        LoanRepaymentJournal: Record "Loan Repayment Journal";
    begin
        // Logic to post the loan application to the loan repayment journal
        LoanRepaymentJournal.Init();
        LoanRepaymentJournal."Member ID" := MemberID;
        LoanRepaymentJournal."Loan Amount" := LoanAmount;
        LoanRepaymentJournal."Loan Duration" := LoanDuration;
        LoanRepaymentJournal."Start Date" := StartDate;
        LoanRepaymentJournal."End Date" := EndDate;
        LoanRepaymentJournal."Monthly Payment" := MonthlyPayment;
        LoanRepaymentJournal."Total Interest" := TotalInterest;
        LoanRepaymentJournal."Total Amount" := TotalAmount;
        LoanRepaymentJournal.Insert();
    end;

    local procedure PostLoanRepayment(RepaymentAmount: Decimal)
    var
        LoanRepaymentJournal: Record "Loan Repayment Journal";
    begin
        // Logic to post loan repayment
        LoanRepaymentJournal.Init();
        LoanRepaymentJournal."Member ID" := MemberID;
        LoanRepaymentJournal."Repayment Amount" := RepaymentAmount;
        LoanRepaymentJournal.Insert();
    end;

    local procedure PostPayment(PaymentAmount: Decimal)
    var
        PaymentJournal: Record "Payment Journal";
    begin
        // Logic to post payment
        PaymentJournal.Init();
        PaymentJournal."Member ID" := MemberID;
        PaymentJournal."Payment Amount" := PaymentAmount;
        PaymentJournal.Insert();
    end;

    // New procedure to validate loan application
    local procedure ValidateLoanApplication(): Boolean
    begin
        if LoanAmount <= 0 then begin
            Message('Please enter a valid loan amount.');
            exit(false);
        end;

        // Additional validation logic can be added here
        exit(true);
    end;
}
