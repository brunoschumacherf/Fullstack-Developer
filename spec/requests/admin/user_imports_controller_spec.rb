require "rails_helper"

RSpec.describe Admin::UserImportsController, type: :request do
  it "does not enqueue an import for an unsupported file" do
    upload = Rack::Test::UploadedFile.new(StringIO.new("notes"), "text/plain", original_filename: "notes.txt")
    expect do
      post admin_user_imports_path, params: { file: upload }
    end.not_to have_enqueued_job(ProcessUserImportJob)
    expect(UserImport.count).to eq(0)
    expect(response).to redirect_to(admin_dashboard_path)
    expect(flash[:alert]).to be_present
  end

  before do
    sign_in_as users(:admin)
  end

  it "enqueues an import job" do
    expect do
      post admin_user_imports_path, params: {
        file: fixture_file_upload("users.csv", "text/csv")
      }
    end.to have_enqueued_job(ProcessUserImportJob)

    expect(response).to redirect_to(admin_dashboard_path)
    expect(UserImport.last.pending?).to be_truthy
  end

  it "returns import props as json" do
    import = users(:admin).user_imports.new
    import.file.attach(
      io: file_fixture("users.csv").open,
      filename: "users.csv",
      content_type: "text/csv"
    )
    import.save!

    get admin_user_import_path(import)
    expect(response).to have_http_status(:success)
    body = JSON.parse(response.body)
    expect(body["id"]).to eq(import.id)
    expect(body["status"]).to eq("pending")
  end
end
