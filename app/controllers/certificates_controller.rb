require 'zip'

class CertificatesController < ApplicationController
  before_action :set_certificate, only: %i[ show edit update destroy ]

  # GET /certificates or /certificates.json
  def index
    @certificates = Certificate.all
  end

  # GET /certificates/1 or /certificates/1.json
  def show
  end

  # GET /certificates/new
  def new
    @certificate = Certificate.new(operator_email: Profile.email, operator_name: Profile.name, operator_affiliation: Profile.o)
  end

  # GET /certificates/1/edit
  def edit
  end


  # POST /certificates or /certificates.json
  def create
    @certificate = Certificate.new(certificate_params.except(:passphrase))
    
    if @certificate.valid?
      generate_and_download_certificate_zip(@certificate, passphrase_param)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /certificates/1 or /certificates/1.json
  def update
    if @certificate.update(certificate_params.except(:passphrase))
      generate_and_download_certificate_zip(@certificate, passphrase_param, :update)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /certificates/1 or /certificates/1.json
  def destroy
  end

  def revoke
    certificate = Certificate.find(params[:id])
    certificate.assign_attributes(certificate_params)
    file_folder = File.join(Rails.root,'tmp')
    file_name_body = "#{certificate.operator_fqdn}"
    tsv = File.join(file_folder, "#{file_name_body}.tsv")
    File.write(tsv, certificate.revoke_tsv)
    send_data(File.read(tsv), filename: "#{file_name_body}.tsv")
    File.unlink(tsv)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_certificate
      @certificate = Certificate.find(params[:id])
    end

    # パスフレーズは一時的にメモリ内でのみ使用し、データベースには保存しない
    def passphrase_param
      params.dig(:certificate, :passphrase)
    end

    # 証明書ファイル生成とダウンロード処理の共通メソッド
    # セキュリティ: 秘密鍵は一時ファイルとして生成され、処理後すぐに削除される
    def generate_and_download_certificate_zip(certificate, passphrase, action_type = :create)
      file_folder = File.join(Rails.root, 'tmp')
      file_name_body = certificate.operator_fqdn
      
      private_key = File.join(file_folder, "#{file_name_body}.key")
      zip = File.join(file_folder, "#{file_name_body}.zip")
      tsv = File.join(file_folder, "#{file_name_body}.tsv")

      begin
        # 秘密鍵とTSVファイルを一時的に生成
        File.write(private_key, certificate.cipher_key_pem(passphrase))
        tsv_content = action_type == :update ? certificate.update_tsv : certificate.new_tsv
        File.write(tsv, tsv_content)
        
        target_files = [private_key, tsv]

        # ZIPファイル作成
        ::Zip::File.open(zip, Zip::File::CREATE) do |zipfile|
          target_files.each do |file|
            zipfile.add File.basename(file), file
          end
        end

        # ダウンロード送信
        send_data(File.read(zip),
                  filename: "#{file_name_body}.zip",
                  type: 'application/zip',
                  disposition: 'attachment')
      ensure
        # セキュリティ: 一時ファイルを確実に削除
        cleanup_temporary_files([zip, private_key, tsv])
        # パスフレーズ変数をクリア
        passphrase = nil
      end
    end

    # 一時ファイルの安全な削除
    def cleanup_temporary_files(files)
      files.each do |file|
        File.unlink(file) if File.exist?(file)
      end
    end

    # Only allow a list of trusted parameters through.
    # passphraseは許可するが.except(:passphrase)で明示的に除外してデータベースに保存しない
    def certificate_params
      params.require(:certificate).permit(:id, :apply_id, :operation_id, :ignore_flag, :subject_dn, :domain_id, :submitted, :completed, :operator_id, :category, :task_model, :profile_id, :status, :operator_name, :operator_affiliation, :operator_email, :operator_fqdn, :operator_software, :csr, :dnsname, :comfirmed_items_flag, :transaction_id, :api_erro_code, :cetification, :serial_no, :finger_print, :cert_start, :cert_exp, :access_pin, :other_subject_address1, :other_subject_address2, :revocation_id, :revocation_submission, :revocation_completed, :revocation_operator_id, :revocation_reason_code, :revocation_reason, :revocation_confirm_code, :revocation_transaction_id, :revocation_authority_error_code, :revocation_operator_email, :old_certificate_serial_no, :certificate_replace_mail_flag, :download_method, :last_updated, :upload_file, :passphrase)
    end
end
