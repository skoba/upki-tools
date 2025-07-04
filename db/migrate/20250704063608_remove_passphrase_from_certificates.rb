class RemovePassphraseFromCertificates < ActiveRecord::Migration[8.0]
  def change
    remove_column :certificates, :passphrase, :string
  end
end
