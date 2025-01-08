report 50101 "Loan Summary Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Loan Summary Report.rdl';
    Caption = 'Loan Summary Report';

    dataset
    {
        dataitem("Posted Loan Repayments Ledger"; "Posted Loan Repayments Ledger")
        {
            DataItemTableView = where("Entry Type" = const(Loan));
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
            column(Status; Status)
            {
            }
            column(Remaining_Amount; "Remaining Amount")
            {
            }
        }
    }
}