require "test_helper"

class UserImportTest < ActiveSupport::TestCase
  test "requires a spreadsheet file" do
    import = users(:admin).user_imports.new
    assert_not import.valid?
    assert_includes import.errors[:file], I18n.t("errors.messages.blank")
  end

  test "rejects unsupported file types" do
    import = users(:admin).user_imports.new
    import.file.attach(
      io: StringIO.new("not a spreadsheet"),
      filename: "notes.txt",
      content_type: "text/plain"
    )

    assert_not import.valid?
    assert_includes import.errors[:file], I18n.t("activerecord.errors.models.user_import.attributes.file.invalid_type")
  end

  test "computes progress percentage" do
    import = users(:admin).user_imports.new(total_rows: 4, processed_rows: 1)
    assert_equal 25, import.progress_percentage
  end

  test "returns zero progress when there are no rows" do
    import = users(:admin).user_imports.new(total_rows: 0, processed_rows: 0)
    assert_equal 0, import.progress_percentage
  end
end
