require_relative "csv_parser"
require_relative "excel_parser"

module UserImports
  module ParserFactory
    CSV_EXTENSION    = "csv"
    EXCEL_EXTENSIONS = %w[xlsx xls ods].freeze

    def self.parse(path, extension)
      case extension.to_s.strip.downcase
      when CSV_EXTENSION
        CsvParser.new(path).rows
      when *EXCEL_EXTENSIONS
        ExcelParser.new(path, extension).rows
      else
        raise ArgumentError, "Formato de arquivo não suportado: .#{extension}"
      end
    end
  end
end
