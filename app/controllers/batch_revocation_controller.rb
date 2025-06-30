class BatchRevocationController < ApplicationController
  def index
    session[:certificate_ids] = batch_revocation_params[:ids]
    @certificates = Certificate.where id: session[:certificate_ids]
  end

  def destroy   
    certificates = Certificate.where id: session[:certificate_ids]
    file_folder = File.join(Rails.root,'tmp')
    file_name_body = "batch_revocation"
    tsv_file = (File.join(file_folder, "#{file_name_body}.tsv"))
    tsv = ''
    certificates.each do |certificate|
      certificate.assign_attributes(operator_name: form_params[:operator_name], operator_email: form_params[:operator_email], revocation_reason_code: form_params[:revocation_reason_code], revocation_reason: form_params[:revocation_reason])
      tsv << certificate.revoke_tsv
    end
    File.write(tsv_file, tsv, encoding: Encoding::SJIS)
    send_data(File.read(tsv_file), filename: "#{file_name_body}.tsv")
    File.unlink(tsv_file)
    reset_session
  end

  private
  def batch_revocation_params
    params.permit(ids: [])
  end

  def form_params
    params.permit(:operator_name, :operator_email, :revocation_reason_code, :revocation_reason)
  end
end
