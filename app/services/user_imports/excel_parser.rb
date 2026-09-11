require "roo"

module UserImports
  class ExcelParser
    def initialize(path, extension)
      @path      = path
      @extension = extension
    end

    def rows
      spreadsheet = Roo::Spreadsheet.open(@path, extension: @extension)
      sheet       = spreadsheet.sheet(0)
      headers     = sheet.row(1).map { |h| h.to_s.strip.downcase }

      (2..sheet.last_row).filter_map do |row_index|
        normalize(headers.zip(sheet.row(row_index)).to_h)
      end
    end

    private

    def normalize(row)
      normalized = row.stringify_keys.transform_keys { |k| k.to_s.strip.downcase }
      return if normalized.values.all?(&:blank?)

      normalized
    end
  end
end
