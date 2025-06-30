# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_03_07_033412) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "certificates", force: :cascade do |t|
    t.string "apply_id"
    t.string "operation_id"
    t.integer "ignore_flag"
    t.string "subject_dn"
    t.string "domain_id"
    t.datetime "submitted", precision: nil
    t.datetime "completed", precision: nil
    t.string "operator_id"
    t.integer "category"
    t.integer "task_model"
    t.string "profile_id"
    t.integer "status"
    t.string "operator_name"
    t.string "operator_affiliation"
    t.string "operator_email"
    t.string "operator_fqdn"
    t.string "operator_software"
    t.string "csr"
    t.string "dnsname"
    t.integer "comfirmed_items_flag"
    t.string "transaction_id"
    t.string "api_erro_code"
    t.string "cetification"
    t.string "serial_no"
    t.string "finger_print"
    t.date "cert_start"
    t.date "cert_exp"
    t.date "url_exp"
    t.string "access_pin"
    t.string "other_subject_address1"
    t.string "other_subject_address2"
    t.string "revocation_id"
    t.string "revocation_operation_id"
    t.datetime "revocation_submitted", precision: nil
    t.datetime "revocation_completed", precision: nil
    t.string "revocation_operator_id"
    t.integer "revocation_reason_code"
    t.string "revocation_reason"
    t.string "revocation_confirm_code"
    t.string "revocation_transaction_id"
    t.string "revocation_authority_error_code"
    t.string "revocation_operator_email"
    t.string "old_certificate_serial_no"
    t.integer "certificate_replace_mail_flag"
    t.string "download_method"
    t.datetime "last_updated", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "domains", force: :cascade do |t|
    t.string "full_name"
    t.integer "person_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_domains_on_person_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "name"
    t.string "organization"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "domains", "people"
end
