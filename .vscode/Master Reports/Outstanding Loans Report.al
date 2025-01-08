report 50103 "Outstanding Loans Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Outstanding Loans Report.rdl';
    Caption = 'Outstanding Loans Report';

    dataset
    {
        dataitem("Posted Loan Repayments Ledger"; "Posted Loan Repayments Ledger")
        {
            DataItemTableView = where("Entry Type" = const(Loan), Status = const(Active));
            column(Loan_ID; "Loan ID")
            {
            }
            column(Member_ID; "Member ID")
            {
            }
            column(Amount; Amount)
            {
            }
            column(Posting_Date; "Posting Date")
            {
            }
            column(Remaining_Amount; "Remaining Amount")
            {
            }
            column(Description; Description)
            {
            }
        }
    }
}