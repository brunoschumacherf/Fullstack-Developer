require "csv"
require "roo"

module UserImports
  class Processor
    def initialize(user_import)
      @user_import = user_import
    end

    def self.call(user_import)
      new(user_import).call
    end

    def call
      @user_import.processing!
      rows = spreadsheet_rows
      @user_import.update!(
        total_rows: rows.size,
        processed_rows: 0,
        successful_rows: 0,
        failed_rows: 0,
        error_messages: []
      )

      rows.each_with_index do |row, index|
        import_row(row, index + 2)
        @user_import.increment!(:processed_rows)
      end

      @user_import.completed!
    rescue StandardError => error
      @user_import.update!(
        status: :failed,
        error_messages: Array(@user_import.error_messages) + [ error.message ]
      )
    end

    private

    def spreadsheet_rows
      @user_import.file.open do |file|
        extension = File.extname(@user_import.file.filename.to_s).delete(".").downcase
        if extension == "csv"
          csv_rows(file.path)
        else
          excel_rows(file.path, extension)
        end
      end
    end

    def csv_rows(path)
      table = CSV.read(path, headers: true, encoding: "bom|utf-8")
      table.filter_map { |row| normalize_row(row.to_h) }
    end

    def excel_rows(path, extension)
      spreadsheet = Roo::Spreadsheet.open(path, extension: extension)
      sheet = spreadsheet.sheet(0)
      headers = sheet.row(1).map { |header| header.to_s.strip.downcase }
      (2..sheet.last_row).filter_map do |row_index|
        normalize_row(headers.zip(sheet.row(row_index)).to_h)
      end
    end

    def normalize_row(row)
      normalized = row.stringify_keys.transform_keys { |key| key.to_s.strip.downcase }
      return if normalized.values.all? { |value| value.blank? }

      normalized
    end

    def import_row(row, line_number)
      user = User.new(
        full_name: row["full_name"] || row["name"] || row["nome"],
        email_address: row["email"] || row["email_address"],
        password: SecureRandom.hex(8),
        role: normalized_role(row["role"] || row["perfil"]),
        avatar_url: row["avatar_url"] || row["avatar"]
      )

      if user.save
        @user_import.increment!(:successful_rows)
      else
        @user_import.increment!(:failed_rows)
        append_error(I18n.t("imports.row_error", line: line_number, messages: user.errors.full_messages.to_sentence))
      end
    end

    def normalized_role(value)
      %w[admin administrador administradora].include?(value.to_s.strip.downcase) ? :admin : :member
    end

    def append_error(message)
      messages = Array(@user_import.error_messages) + [ message ]
      @user_import.update!(error_messages: messages)
    end
  end
end
