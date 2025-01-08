table 50107 "Payment Journal"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "Member ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Payment Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Payment Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Payment Method"; Option)
        {
            OptionMembers = "M-Pesa","Bank Transfer","Cash";
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}