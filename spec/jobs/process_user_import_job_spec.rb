require "rails_helper"

RSpec.describe ProcessUserImportJob, type: :job do
  it "processes a pending import" do
    import = users(:admin).user_imports.new
    import.file.attach(
      io: file_fixture("users.csv").open,
      filename: "users.csv",
      content_type: "text/csv"
    )
    import.save!

    expect do
      ProcessUserImportJob.perform_now(import.id)
    end.to change(User, :count).by(2)

    expect(import.reload.completed?).to be_truthy
  end

  it "skips imports that already finished" do
    import = users(:admin).user_imports.new(status: :completed)
    import.file.attach(
      io: file_fixture("users.csv").open,
      filename: "users.csv",
      content_type: "text/csv"
    )
    import.save!

    expect do
      ProcessUserImportJob.perform_now(import.id)
    end.not_to change(User, :count)
  end
end
