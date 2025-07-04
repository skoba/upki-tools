# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'
require 'date'
TSV_FILE=Rails.root.join('db', 'serverAll.tsv')

if File.exist?(TSV_FILE)
  Certificate.read_tsv(TSV_FILE)
else
  puts "TSV file not found: #{TSV_FILE}. Creating sample data..."
  
  # Create sample certificates
  Certificate.create!(
    apply_id: "SAMPLE001",
    operation_id: "OP001",
    ignore_flag: 0,
    subject_dn: "CN=example.com,OU=IT Department,O=Sample Organization,L=Tokyo,ST=Tokyo,C=JP",
    domain_id: "domain001",
    submitted: 1.day.ago,
    completed: Time.current,
    operator_id: "admin001",
    category: 1,
    task_model: 1,
    profile_id: "profile001",
    status: 1,
    operator_name: "管理者",
    operator_affiliation: "IT部門",
    operator_email: "admin@example.com",
    operator_fqdn: "example.com",
    operator_software: "OpenSSL",
    dnsname: "example.com",
    comfirmed_items_flag: 1,
    transaction_id: "TXN001",
    cert_start: Date.current,
    cert_exp: Date.current + 1.year,
    url_exp: Date.current + 1.year,
    access_pin: "PIN123",
    download_method: "web",
    last_updated: Time.current
  )
  
  Certificate.create!(
    apply_id: "SAMPLE002",
    operation_id: "OP002",
    ignore_flag: 0,
    subject_dn: "CN=test.example.com,OU=IT Department,O=Sample Organization,L=Tokyo,ST=Tokyo,C=JP",
    domain_id: "domain002",
    submitted: 2.days.ago,
    completed: 1.day.ago,
    operator_id: "admin002",
    category: 1,
    task_model: 1,
    profile_id: "profile002",
    status: 1,
    operator_name: "テスト管理者",
    operator_affiliation: "IT部門",
    operator_email: "test@example.com",
    operator_fqdn: "test.example.com",
    operator_software: "OpenSSL",
    dnsname: "test.example.com",
    comfirmed_items_flag: 1,
    transaction_id: "TXN002",
    cert_start: Date.current,
    cert_exp: Date.current + 1.year,
    url_exp: Date.current + 1.year,
    access_pin: "PIN456",
    download_method: "web",
    last_updated: Time.current
  )
  
  puts "Sample data created: #{Certificate.count} certificates"
end
