codeunit 50102 "Loan Repayment Posting"
{
    procedure PostLoanApplication(var LoanRepaymentJournal: Record "Loan Repayment Journal"): Boolean
    var
        PostedLoanLedger: Record "Posted Loan Repayments Ledger";
        EntryNo: Integer;
    begin
        // Get the next entry number
        if PostedLoanLedger.FindLast() then
            EntryNo := PostedLoanLedger."Entry No." + 1
        else
            EntryNo := 1;

        // Create posted entry
        PostedLoanLedger.Init();
        PostedLoanLedger."Entry No." := EntryNo;
        PostedLoanLedger."Posting Date" := LoanRepaymentJournal."Posting Date";
        PostedLoanLedger."Document No." := GetNextDocumentNo();
        PostedLoanLedger."Member ID" := LoanRepaymentJournal."Member ID";
        PostedLoanLedger."Entry Type" := PostedLoanLedger."Entry Type"::Loan;
        PostedLoanLedger.Amount := LoanRepaymentJournal.Amount;
        PostedLoanLedger.Status := PostedLoanLedger.Status::Active;
        PostedLoanLedger.Description := 'Loan Application';
        PostedLoanLedger."Loan ID" := Format(EntryNo, 6, '<Integer,6><Filler Character,0>');
        PostedLoanLedger."Remaining Amount" := LoanRepaymentJournal.Amount;

        exit(PostedLoanLedger.Insert(true));
    end;

    procedure PostRepayment(var LoanRepaymentJournal: Record "Loan Repayment Journal"): Boolean
    var
        PostedLoanLedger: Record "Posted Loan Repayments Ledger";
        EntryNo: Integer;
    begin
        // Get the next entry number
        if PostedLoanLedger.FindLast() then
            EntryNo := PostedLoanLedger."Entry No." + 1
        else
            EntryNo := 1;

        // Create posted entry
        PostedLoanLedger.Init();
        PostedLoanLedger."Entry No." := EntryNo;
        PostedLoanLedger."Posting Date" := Today;
        PostedLoanLedger."Document No." := GetNextDocumentNo();
        PostedLoanLedger."Member ID" := LoanRepaymentJournal."Member ID";
        PostedLoanLedger."Entry Type" := PostedLoanLedger."Entry Type"::Repayment;
        PostedLoanLedger.Amount := -LoanRepaymentJournal."Repayment Amount";
        PostedLoanLedger.Status := PostedLoanLedger.Status::Active;
        PostedLoanLedger.Description := 'Loan Repayment';
        PostedLoanLedger."Loan ID" := LoanRepaymentJournal."Loan ID";
        PostedLoanLedger."Repayment Amount" := LoanRepaymentJournal."Repayment Amount";

        // Update remaining amount on the original loan entry
        UpdateLoanRemainingAmount(
            LoanRepaymentJournal."Loan ID",
            LoanRepaymentJournal."Repayment Amount"
        );

        exit(PostedLoanLedger.Insert(true));
    end;

    local procedure UpdateLoanRemainingAmount(LoanID: Code[20]; RepaymentAmount: Decimal)
    var
        PostedLoanLedger: Record "Posted Loan Repayments Ledger";
    begin
        PostedLoanLedger.Reset();
        PostedLoanLedger.SetRange("Loan ID", LoanID);
        PostedLoanLedger.SetRange("Entry Type", PostedLoanLedger."Entry Type"::Loan);
        if PostedLoanLedger.FindFirst() then begin
            PostedLoanLedger."Remaining Amount" -= RepaymentAmount;
            if PostedLoanLedger."Remaining Amount" <= 0 then
                PostedLoanLedger.Status := PostedLoanLedger.Status::Completed;
            PostedLoanLedger.Modify();
        end;
    end;

    local procedure GetNextDocumentNo(): Code[20]
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Setup: Record "General Ledger Setup";
        LastNo: Integer;
        PostedLoanLedger: Record "Posted Loan Repayments Ledger";
    begin
        if Setup.Get() and (Setup."Loan Nos." <> '') then begin
            Setup.TestField("Loan Nos.");
            exit(NoSeriesMgt.GetNextNo(Setup."Loan Nos.", Today, true));
        end else begin
            // Fallback to auto-generated number if no number series is set up
            if PostedLoanLedger.FindLast() then begin
                Evaluate(LastNo, CopyStr(PostedLoanLedger."Document No.", 5));
                LastNo += 1;
            end else
                LastNo := 1;
            exit(StrSubstNo('LOAN%1', Format(LastNo, 6, '<Integer,6><Filler Character,0>')));
        end;
    end;

    procedure GenerateUniqueLoanID(): Code[20]
    var
        PostedLoanLedger: Record "Posted Loan Repayments Ledger";
        LoanID: Code[20];
        LastNumber: Integer;
    begin
        PostedLoanLedger.Reset();
        // Find the last loan ID in the Posted Loan Ledger
        if PostedLoanLedger.FindLast() then begin
            // Extract the number from the last loan ID
            if not Evaluate(LastNumber, CopyStr(PostedLoanLedger."Loan ID", 6)) then
                LastNumber := 0; // If conversion fails, start from 0
            LastNumber += 1; // Increment to get the next ID
        end else
            LastNumber := 1; // Start with 1 if no loans exist

        // Format: LOAN00001
        LoanID := StrSubstNo('LOAN%1', Format(LastNumber, 5, '<Integer,5><Filler Character,0>'));
        exit(LoanID);
    end;
}
