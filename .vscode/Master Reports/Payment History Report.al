report 50102 "Payment History Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Payment History Report.rdl';
    Caption = 'Payment History Report';

    dataset
    {
        dataitem("Posted Loan Repayments Ledger"; "Posted Loan Repayments Ledger")
        {
            DataItemTableView = where("Entry Type" = const(Repayment));
            column(Document_No_; "Document No.")
            {
            }
            column(Member_ID; "Member ID")
            {
            }
            column(Loan_ID; "Loan ID")
            {
            }
            column(Repayment_Amount; "Repayment Amount")
            {
            }
            column(Posting_Date; "Posting Date")
            {
            }
            column(Description; Description)
            {
            }
        }
    }
}