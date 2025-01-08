tableextension 50100 "General Ledger Setup Ext" extends "General Ledger Setup"
{
    fields
    {
        field(50100; "Loan Nos."; Code[20])
        {
            Caption = 'Loan Number Series';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
    }
}