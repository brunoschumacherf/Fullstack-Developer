require "csv"

module UserImports
  class CsvParser
    def initialize(path)
      @path = path
    end

    def rows
      table = CSV.read(@path, headers: true, encoding: "bom|utf-8")
      table.filter_map { |row| normalize(row.to_h) }
    end

    private

    def normalize(row)
      normalized = row.stringify_keys.transform_keys { |k| k.to_s.strip.downcase }
      return if normalized.values.all?(&:blank?)

      normalized
    end
  end
end
