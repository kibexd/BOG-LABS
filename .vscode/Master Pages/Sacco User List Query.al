/// <summary>
/// Page Sacco User List Query (ID 50100).
/// Displays a list of Sacco users with filtering and export capabilities.
/// </summary>
page 50139 "Sacco User Query"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Sacco User";
    CardPageId = "Sacco User Card";
    Editable = false;

    layout
    {
        area(Content)
        {
            group(FilterGroup)
            {
                Caption = 'Filters';
                field(RoleFilter; RoleFilter)
                {
                    Caption = 'User Role Filter';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if RoleFilter <> RoleFilter::" " then
                            Rec.SetRange("User Role", RoleFilter - 1)
                        else
                            Rec.SetRange("User Role");
                        CurrPage.Update();
                    end;
                }
                field(StatusFilter; StatusFilter)
                {
                    Caption = 'Status Filter';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if StatusFilter <> StatusFilter::" " then
                            Rec.SetRange(Status, StatusFilter - 1)
                        else
                            Rec.SetRange(Status);
                        CurrPage.Update();
                    end;
                }
                field(SavingsFilter; MinSavingsAmount)
                {
                    Caption = 'Minimum Savings';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if MinSavingsAmount <> 0 then
                            Rec.SetFilter(Savings, '>=%1', MinSavingsAmount)
                        else
                            Rec.SetRange(Savings);
                        CurrPage.Update();
                    end;
                }
            }
            repeater(GroupName)
            {
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the User ID';
                }
                field("User Name"; Rec."User Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the User Name';
                }
                field("Email"; Rec."Email")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Email';
                }
                field("User Role"; Rec."User Role")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the User Role';
                }
                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the First Name';
                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Last Name';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Phone Number';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Status';
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Location';
                }
                field(Savings; Rec.Savings)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Savings amount';
                }
                field(LoanBalance; Rec.LoanBalance)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Loan Balance';
                }
                field("Registration Time"; Rec."Registration Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the user was registered';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ExportExcel)
            {
                ApplicationArea = All;
                Caption = 'Export to Excel';
                Image = ExportToExcel;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Export the list to Excel';

                trigger OnAction()
                begin
                    ExportSaccoUsersToExcel();
                end;
            }
            action(PrintReport)
            {
                ApplicationArea = All;
                Caption = 'Print Report';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Print Sacco Users Report';

                trigger OnAction()
                begin
                    Report.Run(Report::"Sacco Users Report", true, false, Rec);
                end;
            }
            action(ClearFilters)
            {
                ApplicationArea = All;
                Caption = 'Clear Filters';
                Image = ClearFilter;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ClearAllFilters();
                end;
            }
        }
    }

    var
        RoleFilter: Option " ",Member,Admin;
        StatusFilter: Option " ",Active,Inactive;
        MinSavingsAmount: Decimal;

    local procedure ClearAllFilters()
    begin
        RoleFilter := RoleFilter::" ";
        StatusFilter := StatusFilter::" ";
        MinSavingsAmount := 0;
        Rec.Reset();
        CurrPage.Update();
    end;

    local procedure ExportSaccoUsersToExcel()
    var
        SaccoUser: Record "Sacco User";
        TempExcelBuffer: Record "Excel Buffer" temporary;
        ExcelFileName: Text;
        ExportToExcelLbl: Label 'Sacco Users';
    begin
        SaccoUser.Copy(Rec); // Copy current filters

        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();

        // Add Headers
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('User ID', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('User Name', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Email', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Role', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Status', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Savings', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('Loan Balance', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);

        // Add Data
        if SaccoUser.FindSet() then
            repeat
                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(SaccoUser."User ID", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SaccoUser."User Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SaccoUser.Email, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Format(SaccoUser."User Role"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Format(SaccoUser.Status), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SaccoUser.Savings, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(SaccoUser.LoanBalance, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            until SaccoUser.Next() = 0;

        ExcelFileName := ExportToExcelLbl;
        TempExcelBuffer.CreateNewBook(ExcelFileName);
        TempExcelBuffer.WriteSheet(ExportToExcelLbl, CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.OpenExcel();
    end;
}