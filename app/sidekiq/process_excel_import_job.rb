class ProcessExcelImportJob
  include Sidekiq::Job

  # Prevent retry as the file is always removed at the end of this process.
  sidekiq_options retry: false

  def perform(user_id)
    user = User.find(user_id)
    import_file = user.import_file

    # Get the original filename
    original_file_name = import_file.filename.to_s

    # Create a new ImportResult record with the "processing" status
    import_result = user.import_results.create(
      status: :processing,
      message: "",
      filename: original_file_name
    )

    # Open the file using the Active Storage blob
    import_file.open do |temp_file|
      # Process the Excel file using the ExcelImportService
      excel_import_service = ExcelImportService.new(user)
      success, errors, message = excel_import_service.process_excel_file(temp_file.path)

      # Add error messages if any
      if !errors.nil?
        message << "\n"
        message << errors.join("\n")
      end

      # Update the import result with the final status and message
      import_result.update(
        status: success ? :success : :error,
        message: message
      )
    end

    # Cleanup
    # user.import_file.purge
  end

end
