class AddPassphraseToCertificates < ActiveRecord::Migration[8.0]
  def change
    add_column :certificates, :passphrase, :string
  end
end
