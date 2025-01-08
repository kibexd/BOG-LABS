table 50100 "Sacco User"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "User ID"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "User Name"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Email"; Text[80])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Password"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(5; "User Role"; Option)
        {
            OptionMembers = "Member","Admin";
            DataClassification = CustomerContent;
        }
        field(6; "First Name"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(7; "Last Name"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(8; "Phone No."; Text[20])
        {
            DataClassification = CustomerContent;
        }
        field(9; "Gender"; Option)
        {
            OptionMembers = "Male","Female","Other";
            DataClassification = CustomerContent;
        }
        field(10; "Location"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(11; "Profile Picture"; MediaSet)
        {
            DataClassification = CustomerContent;
        }
        field(12; "Profile Picture Uploaded"; Boolean) // New field to indicate if a profile picture is uploaded
        {
            DataClassification = CustomerContent;
        }
        field(13; "Registration Time"; DateTime) // New field to store registration time
        {
            DataClassification = CustomerContent;
        }
        field(14; Status; Option)
        {
            OptionMembers = Active,Inactive; // Define the valid options
            OptionCaption = 'Active,Inactive'; // Optional: for user-friendly display
        }
        field(15; "Loan Balance"; Decimal) // New field for Loan Balance
        {
            DataClassification = CustomerContent;
        }
        field(16; "Next Payment Date"; Date) // New field for Next Payment Date
        {
            DataClassification = CustomerContent;
        }
        field(17; "Username"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(18; "Savings"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(19; "LoanBalance"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(20; "NextPaymentDate"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(21; Image; MediaSet)  // Using MediaSet instead of Blob for better image handling
        {
            Caption = 'Profile Picture';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "User ID")
        {
            Clustered = true;
        }
    }
}
