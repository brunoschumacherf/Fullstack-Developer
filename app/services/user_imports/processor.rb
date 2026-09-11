require "csv"
require "roo"
require_relative "parser_factory"

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
        ParserFactory.parse(file.path, extension)
      end
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
