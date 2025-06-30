class CreateServers < ActiveRecord::Migration[6.1]
  def change
    create_table :servers do |t|
      t.string :apply_id
      t.string :operation_id
      t.integer :ignore_flag
      t.string :subject_dn
      t.string :domain_id
      t.datetime :submitted
      t.datetime :completed
      t.string :operator_id
      t.integer :category
      t.integer :task_model
      t.string :profile_id
      t.integer :status
      t.string :operator_name
      t.string :operator_affiliation
      t.string :operator_email
      t.string :operator_fqdn
      t.string :operator_software
      t.string :csr
      t.string :dnsname
      t.integer :comfirmed_items_flag
      t.string :transaction_id
      t.string :api_erro_code
      t.string :cetification
      t.string :serial_no
      t.string :finger_print
      t.date :cert_start
      t.date :cert_exp
      t.date :url_exp
      t.string :access_pin
      t.string :other_subject_address1
      t.string :other_subject_address2
      t.string :revocation_id
      t.string  :revocation_operation_id
      t.datetime :revocation_submitted
      t.datetime :revocation_completed
      t.string :revocation_operator_id
      t.integer :revocation_reason_code
      t.string :revocation_reason
      t.string :revocation_confirm_code
      t.string :revocation_transaction_id
      t.string :revocation_authority_error_code
      t.string :revocation_operator_email
      t.string :old_certificate_serial_no
      t.integer :certificate_replace_mail_flag
      t.string :download_method
      t.datetime :last_updated

      t.timestamps
    end
  end
end
