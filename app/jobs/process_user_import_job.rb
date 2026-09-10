require "roo"

class ProcessUserImportJob < ApplicationJob
  queue_as :default

  def perform(user_import_id)
    import = UserImport.find(user_import_id)
    return if import.status == "completed"

    import.update!(status: "processing")
    file_path = ActiveStorage::Blob.service.path_for(import.file.key)

    spreadsheet = Roo::Spreadsheet.open(file_path)
    sheet = spreadsheet.sheet(0)
    
    headers = sheet.row(1).map(&:to_s).map(&:downcase)
    total_rows = sheet.last_row - 1
    import.update!(total_rows: total_rows)

    (2..sheet.last_row).each_with_index do |row_index, i|
      row = Hash[[headers, sheet.row(row_index)].transpose]

      user = User.new(
        full_name: row["full_name"] || row["nome"],
        email_address: row["email"] || row["email_address"],
        password: SecureRandom.hex(10),
        role: (row["role"].to_s.downcase == "admin") ? :admin : :member
      )

      if user.save
        import.increment!(:successful_rows)
      else
        import.increment!(:failed_rows)
        import.error_messages << "Linha #{row_index}: #{user.errors.full_messages.join(', ')}"
      end

      import.update!(processed_rows: i + 1)

      # Transmite atualização em tempo real a cada 5 linhas ou no final
      if (i + 1) % 5 == 0 || (i + 1) == total_rows
        percentage = ((import.processed_rows.to_f / total_rows) * 100).round
        ActionCable.server.broadcast("import_progress_#{import.id}", {
          id: import.id,
          status: import.status,
          total: import.total_rows,
          processed: import.processed_rows,
          percentage: percentage
        })
      end
    end

    import.update!(status: "completed")
    ActionCable.server.broadcast("import_progress_#{import.id}", {
      status: "completed",
      errors: import.error_messages
    })
  end
end