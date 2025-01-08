codeunit 50100 "Loan Journal Management"
{
    procedure GenerateUniqueLoanID(): Code[20]
    var
        LoanJournal: Record "Loan Repayment Journal";
        LastNumber: Integer;
        NewNumber: Integer;
        YearMonth: Text;
        LoanID: Code[20];
    begin
        YearMonth := Format(Today, 0, '<Year4><Month,2>');

        LoanJournal.Reset();
        LoanJournal.SetCurrentKey("Loan ID");
        LoanJournal.SetFilter("Loan ID", YearMonth + '*');

        if LoanJournal.FindLast() then begin
            Evaluate(LastNumber, CopyStr(LoanJournal."Loan ID", 7));
            NewNumber := LastNumber + 1;
        end else
            NewNumber := 1;

        LoanID := YearMonth + Format(NewNumber, 4, '<Integer,4><Filler,0>');
        exit(LoanID);
    end;
}