require "test_helper"

module UserImports
  class ProcessorTest < ActiveSupport::TestCase
    test "imports valid rows and records validation failures" do
      import = build_import("users.csv")

      assert_difference("User.count", 2) do
        UserImports::Processor.call(import)
      end

      import.reload
      assert import.completed?
      assert_equal 3, import.total_rows
      assert_equal 2, import.successful_rows
      assert_equal 1, import.failed_rows
      assert User.exists?(email_address: "imported.one@example.com")
      assert User.exists?(email_address: "imported.admin@example.com")
      assert import.error_messages.any? { |message| message.include?("Linha 4") }
    end

    test "marks the import as failed when the file cannot be parsed" do
      import = users(:admin).user_imports.new
      import.file.attach(
        io: StringIO.new("\xFF\xD8not-csv"),
        filename: "users.csv",
        content_type: "text/csv"
      )
      import.save!

      UserImports::Processor.call(import)

      assert import.reload.failed?
      assert import.error_messages.present?
    end

    private

    def build_import(filename)
      import = users(:admin).user_imports.new
      import.file.attach(
        io: file_fixture(filename).open,
        filename: filename,
        content_type: "text/csv"
      )
      import.save!
      import
    end
  end
end
