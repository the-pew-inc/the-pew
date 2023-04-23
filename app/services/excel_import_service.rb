require "xsv"

class ExcelImportService
  def initialize(user)
    @user = user
  end

  def process_excel_file(file_path)
    # Determine the file extension
    file_extension = File.extname(file_path)

    # Process the Excel file using the appropriate method
    case file_extension
    when ".xlsx"
      success, errors, message = process_xlsx_file(file_path)
    else
      return [false, ["Unsupported file format"]]
    end

    [success, errors, message]
  end

  private

  def process_xlsx_file(file_path)
    errors = []
    processed_records = 0
    error_records = 0

    sheet = Xsv.open(file_path).sheets[0]  # Assuming the data is in the first sheet

    # Iterate through each row in the sheet, starting from the second row (index 1)
    sheet.each_with_index do |row, index|
      next if index.zero? # Skip header row

      email = row[0]
      # role = row[1]

      # Stop processing when an empty row is encountered
      break if email.blank?

      # Validate the email and role
      if email.blank? || !email.match?(URI::MailTo::EMAIL_REGEXP)
        errors << "Row #{index + 1}: Invalid email | #{email}"
        error_records += 1
        processed_records += 1
        next
      end

      # if role.blank? || !["admin", ""].include?(role.downcase)
      #   errors << "Row #{index + 1}: Invalid role"
      #   error_records += 1
      #   next
      # end

      # Create the user
      user = User.new( email: email,
          invited_at: Time.current,
          invited:  true )
      
      # TODO: Assign role using rollify.

      # Save the user, and add an error message if saving fails
      unless user.save
        errors << "Row #{index + 1}: Failed to save user - #{user.errors.full_messages.join(", ")}"
        error_records += 1
        processed_records += 1
        next
      end

      # Assign the user to the organization
      member = Member.new
      member.organization_id = @user.organization.id
      member.user_id = user.id

      unless member.save
        errors << "Row #{index + 1}: Failed to save user to organization - #{member.errors.full_messages.join(", ")}"
        error_records += 1
        processed_records += 1
        next
      end

      # Send email to the user
      user.send_invite!

      # Incrementing the number of processed records
      processed_records += 1

    end

    success = errors.empty?
    message = "Processed records: #{processed_records}, records with errors: #{error_records}"
    [success, errors, message]
  end
end