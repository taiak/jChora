# pdf ve text okumak için bir sınıf
class ReadFiles
    require './jars/pdfbox-app-2.0.13.jar'

    java_import org.apache.pdfbox.pdmodel.PDDocument;
    java_import org.apache.pdfbox.text.PDFTextStripper;
    java_import org.apache.pdfbox.io.RandomAccessFile;
    PDFParser = Java::OrgApachePdfboxPdfparser::PDFParser
    # dosya isimlerini al
    def self.get_file_names(path_pattern)
        Dir.glob(path_pattern)
    end

    def self.read_files(path_pattern)   
        file_hash = {}
        get_file_names(path_pattern).each do |file|
            file_hash[file] = self.read_file file
        end
        file_hash
    end

    def self.read_file(file_name)
        if(file_name.end_with?("pdf"))
            read_pdf(file_name)
        else
            File.read(file_name)
        end
    end
    
    private
    def self.read_pdf(file_name)
        pdfParser = PDFParser.new(RandomAccessFile.new(Java::JavaIo::File.new(file_name), "r"))
        pdfParser.parse()
        pdDocument = PDDocument.new(pdfParser.getDocument());
        text = PDFTextStripper.new.getText(pdDocument);
        pdDocument.close
        text
    end

end
