require "test_helper"

module Admin
  class UserImportsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in_as users(:admin)
    end

    test "enqueues an import job" do
      assert_enqueued_with(job: ProcessUserImportJob) do
        post admin_user_imports_path, params: {
          file: fixture_file_upload("users.csv", "text/csv")
        }
      end

      assert_redirected_to admin_dashboard_path
      assert UserImport.last.pending?
    end

    test "returns import props as json" do
      import = users(:admin).user_imports.new
      import.file.attach(
        io: file_fixture("users.csv").open,
        filename: "users.csv",
        content_type: "text/csv"
      )
      import.save!

      get admin_user_import_path(import)
      assert_response :success
      body = JSON.parse(response.body)
      assert_equal import.id, body["id"]
      assert_equal "pending", body["status"]
    end
  end
end
