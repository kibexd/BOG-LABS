table 50105 "Loan Repayment Journal"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Journal Batch Name"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Repayment ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Member ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Member Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Document Type"; Option)
        {
            OptionMembers = " ",Payment,Invoice,Application;
            DataClassification = ToBeClassified;
        }
        field(9; "Loan ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Loan Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Repayment Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Monthly Repayment Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Repayment Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Loan Purpose"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Repayment Period"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Monthly Payment"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Total Interest"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Total Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Status"; Enum "Loan Repayment Status")
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Loan Duration"; Option)
        {
            OptionMembers = "6","8","12","24";
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Journal Template Name", "Journal Batch Name", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Repayment ID")
        {
        }
    }
}
