require "test_helper"

class ProcessUserImportJobTest < ActiveJob::TestCase
  test "processes a pending import" do
    import = users(:admin).user_imports.new
    import.file.attach(
      io: file_fixture("users.csv").open,
      filename: "users.csv",
      content_type: "text/csv"
    )
    import.save!

    assert_difference("User.count", 2) do
      ProcessUserImportJob.perform_now(import.id)
    end

    assert import.reload.completed?
  end

  test "skips imports that already finished" do
    import = users(:admin).user_imports.new(status: :completed)
    import.file.attach(
      io: file_fixture("users.csv").open,
      filename: "users.csv",
      content_type: "text/csv"
    )
    import.save!

    assert_no_difference("User.count") do
      ProcessUserImportJob.perform_now(import.id)
    end
  end
end
