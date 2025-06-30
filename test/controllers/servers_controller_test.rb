require "test_helper"

class ServersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @server = servers(:one)
  end

  test "should get index" do
    get servers_url
    assert_response :success
  end

  test "should get new" do
    get new_server_url
    assert_response :success
  end

  test "should create server" do
    assert_difference('Server.count') do
      post servers_url, params: { server: { access_pin: @server.access_pin, api_erro_code: @server.api_erro_code, apply_id: @server.apply_id, category: @server.category, cert_exp: @server.cert_exp, cert_start: @server.cert_start, certificate_replace_mail_flag: @server.certificate_replace_mail_flag, cetification: @server.cetification, comfirmed_items_flag: @server.comfirmed_items_flag, completed: @server.completed, csr: @server.csr, dnsname: @server.dnsname, domain_id: @server.domain_id, download_method: @server.download_method, finger_print: @server.finger_print, ignore_flag: @server.ignore_flag, last_updated: @server.last_updated, old_certificate_serial_no: @server.old_certificate_serial_no, operation_id: @server.operation_id, operator_affiliation: @server.operator_affiliation, operator_email: @server.operator_email, operator_fqdn: @server.operator_fqdn, operator_id: @server.operator_id, operator_name: @server.operator_name, operator_software: @server.operator_software, other_subject_address1: @server.other_subject_address1, other_subject_address2: @server.other_subject_address2, profile_id: @server.profile_id, revocation_authority_error_code: @server.revocation_authority_error_code, revocation_completed: @server.revocation_completed, revocation_confirm_code: @server.revocation_confirm_code, revocation_id: @server.revocation_id, revocation_operator_email: @server.revocation_operator_email, revocation_operator_id: @server.revocation_operator_id, revocation_reason: @server.revocation_reason, revocation_reason_code: @server.revocation_reason_code, revocation_submission: @server.revocation_submission, revocation_transaction_id: @server.revocation_transaction_id, serial_no: @server.serial_no, status: @server.status, subject_dn: @server.subject_dn, submitted: @server.submitted, task_model: @server.task_model, transaction_id: @server.transaction_id } }
    end

    assert_redirected_to server_url(Server.last)
  end

  test "should show server" do
    get server_url(@server)
    assert_response :success
  end

  test "should get edit" do
    get edit_server_url(@server)
    assert_response :success
  end

  test "should update server" do
    patch server_url(@server), params: { server: { access_pin: @server.access_pin, api_erro_code: @server.api_erro_code, apply_id: @server.apply_id, category: @server.category, cert_exp: @server.cert_exp, cert_start: @server.cert_start, certificate_replace_mail_flag: @server.certificate_replace_mail_flag, cetification: @server.cetification, comfirmed_items_flag: @server.comfirmed_items_flag, completed: @server.completed, csr: @server.csr, dnsname: @server.dnsname, domain_id: @server.domain_id, download_method: @server.download_method, finger_print: @server.finger_print, ignore_flag: @server.ignore_flag, last_updated: @server.last_updated, old_certificate_serial_no: @server.old_certificate_serial_no, operation_id: @server.operation_id, operator_affiliation: @server.operator_affiliation, operator_email: @server.operator_email, operator_fqdn: @server.operator_fqdn, operator_id: @server.operator_id, operator_name: @server.operator_name, operator_software: @server.operator_software, other_subject_address1: @server.other_subject_address1, other_subject_address2: @server.other_subject_address2, profile_id: @server.profile_id, revocation_authority_error_code: @server.revocation_authority_error_code, revocation_completed: @server.revocation_completed, revocation_confirm_code: @server.revocation_confirm_code, revocation_id: @server.revocation_id, revocation_operator_email: @server.revocation_operator_email, revocation_operator_id: @server.revocation_operator_id, revocation_reason: @server.revocation_reason, revocation_reason_code: @server.revocation_reason_code, revocation_submission: @server.revocation_submission, revocation_transaction_id: @server.revocation_transaction_id, serial_no: @server.serial_no, status: @server.status, subject_dn: @server.subject_dn, submitted: @server.submitted, task_model: @server.task_model, transaction_id: @server.transaction_id } }
    assert_redirected_to server_url(@server)
  end

  test "should destroy server" do
    assert_difference('Server.count', -1) do
      delete server_url(@server)
    end

    assert_redirected_to servers_url
  end
end
