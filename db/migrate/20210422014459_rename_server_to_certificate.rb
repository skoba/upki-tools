class RenameServerToCertificate < ActiveRecord::Migration[6.1]
  def change
    rename_table :servers, :certificates
  end
end
