table 50106 "Posted Loan Repayments Ledger"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Posted Loan Entries";
    LookupPageId = "Posted Loan Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Member ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Sacco User"."User ID";
        }
        field(5; "Entry Type"; Option)
        {
            OptionMembers = "Loan","Repayment";
            DataClassification = ToBeClassified;
        }
        field(6; "Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Status"; Option)
        {
            OptionMembers = "Active","Completed","Defaulted";
            DataClassification = ToBeClassified;
        }
        field(8; "Description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Loan ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Repayment ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Repayment Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Posted Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Remaining Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Member ID", "Posting Date") { }
        key(Key3; "Loan ID") { }
        key(Key4; "Repayment ID") { }
    }
}