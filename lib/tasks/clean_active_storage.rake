# Description:
# A set of functions to be run periodically to clean up the ActiveStorage
# It is used to detect and remove orphaned files and directories as well as orphan blob records

namespace :clean_active_storage do
  # Usage:
  #   - rake clean_active_storage:remove_orphan_blobs
  #   - rake "clean_active_storage:remove_orphan_blobs[false]"
  desc "Remove blobs not associated with any attachment"
  task :remove_orphan_blobs, [:dry_run] => :environment do |_t, args|
    dry_run = true unless args[:dry_run] == "false"

    puts("[#{Time.now}] Running remove_orphan_blobs :: INI#{" (dry_run activated)" if dry_run}")

    ActiveStorage::Blob.where.not(id: ActiveStorage::Attachment.select(:blob_id)).find_each do |blob|
      puts("Deleting Blob: #{ActiveStorage::Blob.service.path_for(blob.key)}#{" (dry_run activated)" if dry_run}")
      blob.purge unless dry_run
    end

    puts("[#{Time.now}] Running remove_orphan_blobs :: END#{" (dry_run activated)" if dry_run}")
  end

  # Usage:
  #   - rake clean_active_storage:remove_orphan_files
  #   - rake "clean_active_storage:remove_orphan_files[false]"
  desc "Remove files not associated with any blob"
  task :remove_orphan_files, [:dry_run] => :environment do |_t, args|
    include ActionView::Helpers::NumberHelper
    dry_run = true unless args.dry_run == "false"

    puts("[#{Time.now}] Running remove_orphan_files :: INI#{" (dry_run activated)" if dry_run}")

    files = Dir["storage/??/??/*"]
    orphan_files = files.select do |file|
      !ActiveStorage::Blob.exists?(key: File.basename(file))
    end

    sum = 0
    orphan_files.each do |file|
      puts("Deleting File: #{file}#{" (dry_run activated)" if dry_run}")
      sum += File.size(file)
      FileUtils.remove(file) unless dry_run
    end

    puts "Size Liberated: #{number_to_human_size(sum)}#{" (dry_run activated)" if dry_run}"

    puts("[#{Time.now}] Running remove_orphan_files :: END#{" (dry_run activated)" if dry_run}")
  end

end
