page 50107 "MSacco Logo"
{
    PageType = CardPart;
    SourceTable = "Msacco Logo";
    UsageCategory = Lists;
    ApplicationArea = "All";


    layout
    {
        area(Content)
        {
            field(Logo; Rec.Logo)
            {
                ApplicationArea = All;
                ShowCaption = false;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(UploadLogo)
            {
                ApplicationArea = All;
                Caption = 'Upload Logo';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    UploadLogoPicture();
                end;
            }

            action(ExportLogo)
            {
                ApplicationArea = All;
                Caption = 'Export Logo';
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ExportLogoPicture();
                end;
            }

            action(DeleteLogo)
            {
                ApplicationArea = All;
                Caption = 'Delete Logo';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    DeleteLogoPicture();
                end;
            }
        }
    }

    var
        OverrideImageQst: Label 'The existing picture will be replaced. Do you want to continue?';
        DeleteImageQst: Label 'Are you sure you want to delete the picture?';

    local procedure UploadLogoPicture()
    var
        PictureInStream: InStream;
        FileName: Text;
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;

        if UploadIntoStream('Select a logo picture to upload', '', 'All Files (*.*)|*.*', FileName, PictureInStream) then begin
            Rec.Logo.ImportStream(PictureInStream, FileName);
            Rec.Modify(true);
            Message('Logo picture uploaded successfully.');
        end;
    end;


    local procedure ExportLogoPicture()
    var
        TempBlob: Codeunit "Temp Blob";
        OutStream: OutStream;
        InStream: InStream;
        FileName: Text;
    begin
        TempBlob.CreateOutStream(OutStream);
        Rec.Logo.ExportStream(OutStream);
        TempBlob.CreateInStream(InStream);
        FileName := 'logo_picture.jpg';
        DownloadFromStream(InStream, 'Export', '', 'All Files (*.*)|*.*', FileName);
    end;

    local procedure DeleteLogoPicture()
    begin
        if not Confirm(DeleteImageQst) then
            exit;

        Rec.Init();
        Rec.Delete();
        Message('Logo picture deleted successfully.');
    end;
}
