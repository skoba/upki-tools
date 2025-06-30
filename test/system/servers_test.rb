require "application_system_test_case"

class ServersTest < ApplicationSystemTestCase
  setup do
    @server = servers(:one)
  end

  test "visiting the index" do
    visit servers_url
    assert_selector "h1", text: "Servers"
  end

  test "creating a Server" do
    visit servers_url
    click_on "New Server"

    fill_in "Access pin", with: @server.access_pin
    fill_in "Api erro code", with: @server.api_erro_code
    fill_in "Apply", with: @server.apply_id
    fill_in "Category", with: @server.category
    fill_in "Cert exp", with: @server.cert_exp
    fill_in "Cert start", with: @server.cert_start
    fill_in "Certificate replace mail flag", with: @server.certificate_replace_mail_flag
    fill_in "Cetification", with: @server.cetification
    fill_in "Comfirmed items flag", with: @server.comfirmed_items_flag
    fill_in "Completed", with: @server.completed
    fill_in "Csr", with: @server.csr
    fill_in "Dnsname", with: @server.dnsname
    fill_in "Domain", with: @server.domain_id
    fill_in "Download method", with: @server.download_method
    fill_in "Finger print", with: @server.finger_print
    fill_in "Ignore flag", with: @server.ignore_flag
    fill_in "Last updated", with: @server.last_updated
    fill_in "Old certificate serial no", with: @server.old_certificate_serial_no
    fill_in "Operation", with: @server.operation_id
    fill_in "Operator affiliation", with: @server.operator_affiliation
    fill_in "Operator email", with: @server.operator_email
    fill_in "Operator fqdn", with: @server.operator_fqdn
    fill_in "Operator", with: @server.operator_id
    fill_in "Operator name", with: @server.operator_name
    fill_in "Operator software", with: @server.operator_software
    fill_in "Other subject address1", with: @server.other_subject_address1
    fill_in "Other subject address2", with: @server.other_subject_address2
    fill_in "Profile", with: @server.profile_id
    fill_in "Revocation authority error code", with: @server.revocation_authority_error_code
    fill_in "Revocation completed", with: @server.revocation_completed
    fill_in "Revocation confirm code", with: @server.revocation_confirm_code
    fill_in "Revocation", with: @server.revocation_id
    fill_in "Revocation operator email", with: @server.revocation_operator_email
    fill_in "Revocation operator", with: @server.revocation_operator_id
    fill_in "Revocation reason", with: @server.revocation_reason
    fill_in "Revocation reason code", with: @server.revocation_reason_code
    fill_in "Revocation submission", with: @server.revocation_submission
    fill_in "Revocation transaction", with: @server.revocation_transaction_id
    fill_in "Serial no", with: @server.serial_no
    fill_in "Status", with: @server.status
    fill_in "Subject dn", with: @server.subject_dn
    fill_in "Submitted", with: @server.submitted
    fill_in "Task model", with: @server.task_model
    fill_in "Transaction", with: @server.transaction_id
    click_on "Create Server"

    assert_text "Server was successfully created"
    click_on "Back"
  end

  test "updating a Server" do
    visit servers_url
    click_on "Edit", match: :first

    fill_in "Access pin", with: @server.access_pin
    fill_in "Api erro code", with: @server.api_erro_code
    fill_in "Apply", with: @server.apply_id
    fill_in "Category", with: @server.category
    fill_in "Cert exp", with: @server.cert_exp
    fill_in "Cert start", with: @server.cert_start
    fill_in "Certificate replace mail flag", with: @server.certificate_replace_mail_flag
    fill_in "Cetification", with: @server.cetification
    fill_in "Comfirmed items flag", with: @server.comfirmed_items_flag
    fill_in "Completed", with: @server.completed
    fill_in "Csr", with: @server.csr
    fill_in "Dnsname", with: @server.dnsname
    fill_in "Domain", with: @server.domain_id
    fill_in "Download method", with: @server.download_method
    fill_in "Finger print", with: @server.finger_print
    fill_in "Ignore flag", with: @server.ignore_flag
    fill_in "Last updated", with: @server.last_updated
    fill_in "Old certificate serial no", with: @server.old_certificate_serial_no
    fill_in "Operation", with: @server.operation_id
    fill_in "Operator affiliation", with: @server.operator_affiliation
    fill_in "Operator email", with: @server.operator_email
    fill_in "Operator fqdn", with: @server.operator_fqdn
    fill_in "Operator", with: @server.operator_id
    fill_in "Operator name", with: @server.operator_name
    fill_in "Operator software", with: @server.operator_software
    fill_in "Other subject address1", with: @server.other_subject_address1
    fill_in "Other subject address2", with: @server.other_subject_address2
    fill_in "Profile", with: @server.profile_id
    fill_in "Revocation authority error code", with: @server.revocation_authority_error_code
    fill_in "Revocation completed", with: @server.revocation_completed
    fill_in "Revocation confirm code", with: @server.revocation_confirm_code
    fill_in "Revocation", with: @server.revocation_id
    fill_in "Revocation operator email", with: @server.revocation_operator_email
    fill_in "Revocation operator", with: @server.revocation_operator_id
    fill_in "Revocation reason", with: @server.revocation_reason
    fill_in "Revocation reason code", with: @server.revocation_reason_code
    fill_in "Revocation submission", with: @server.revocation_submission
    fill_in "Revocation transaction", with: @server.revocation_transaction_id
    fill_in "Serial no", with: @server.serial_no
    fill_in "Status", with: @server.status
    fill_in "Subject dn", with: @server.subject_dn
    fill_in "Submitted", with: @server.submitted
    fill_in "Task model", with: @server.task_model
    fill_in "Transaction", with: @server.transaction_id
    click_on "Update Server"

    assert_text "Server was successfully updated"
    click_on "Back"
  end

  test "destroying a Server" do
    visit servers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Server was successfully destroyed"
  end
end
