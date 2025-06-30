require 'openssl'
require 'csv'
require 'date'

class Certificate < ApplicationRecord
#  attr_accessor :software

  def cipher_key
    @cipher_key ||= OpenSSL::PKey::RSA.generate(2048)
  end

  def cipher_key_pem(passphrase = nil)
    if passphrase.present?
      cipher_key.to_pem(OpenSSL::Cipher.new('AES-256-CBC'), passphrase)
    else
      cipher_key.to_pem
    end
  end

  def dn
    if subject_dn
      subject_dn
    else
      @dn = "CN=#{operator_fqdn},"
      @dn += "OU=#{Profile.ou}," if Profile.ou
      @dn += "O=#{Profile.o},"
      @dn += "L=#{Profile.l},"
      @dn += "ST=#{Profile.st},"
      @dn += "C=#{Profile.c}"
    end
  end

  def dn2entries
    dn.delete("\n").split(',').map do |item|
      item.split('=')
    end
  end

  def csr_main
    csr = OpenSSL::X509::Request.new
    name = OpenSSL::X509::Name.new(dn2entries)
    csr.subject = name
    csr.public_key =cipher_key.public_key
#    factory = OpenSSL::X509::ExtensionFactory.new
    csr.sign(cipher_key, 'sha256').to_pem.lines[1..-2].join.delete("\n")
  end

  def new_tsv
    "#{dn}\t3\t\t\t\t\t#{csr_main}\t#{operator_name}\t#{operator_affiliation}\t#{operator_email}\t#{operator_fqdn}\t#{operator_software}\t\n"
  end

  def update_tsv
    "#{dn}\t3\t\t#{serial_no}\t\t\t#{csr_main}\t#{operator_name}\t#{operator_affiliation}\t#{operator_email}\t#{operator_fqdn}\t#{operator_software}\t\n"
  end

  def revoke_tsv
    "#{dn}\t\t\t#{serial_no}\t#{revocation_reason_code}\t#{revocation_reason}\t\t\t\t#{operator_email}\t\t\t\n"
  end

  def self.read_tsv(tsv_file)
    CSV.open(tsv_file, 'r', headers: :first_row, col_sep: "\t", encoding: Encoding::SHIFT_JIS).each do |certificate|
      Certificate.create(
        apply_id: certificate[0],
        operation_id: certificate[1],
        ignore_flag: certificate[2],
        subject_dn: certificate[3],
        domain_id: certificate[4],
        submitted: certificate[5], #.sub("\s", 'T')+"+09:00",
        completed: certificate[6],
        operator_id: certificate[7],
        category: certificate[8],
        task_model: certificate[9],
        profile_id: certificate[10],
        status: certificate[11],
        operator_name: certificate[12],
        operator_affiliation: certificate[13],
        operator_email: certificate[14],
        operator_fqdn: certificate[15],
        operator_software: certificate[16],
        csr: certificate[17],
        dnsname: certificate[18],
        comfirmed_items_flag: certificate[19],
        transaction_id: certificate[20],
        api_erro_code: certificate[21],
        cetification: certificate[22],
        serial_no: certificate[23],
        finger_print: certificate[24],
        cert_start: certificate[25],
        cert_exp: certificate[26],
        url_exp: certificate[27],
        access_pin: certificate[28],
        other_subject_address1: certificate[29],
        other_subject_address2: certificate[30],
        revocation_id: certificate[31],
        revocation_operation_id: certificate[32],
        revocation_submitted: certificate[33],
        revocation_completed: certificate[34],
        revocation_operator_id: certificate[35],
        revocation_reason_code: certificate[36],
        revocation_reason: certificate[37],
        revocation_confirm_code: certificate[38],
        revocation_transaction_id: certificate[39],
        revocation_authority_error_code: certificate[40],
        revocation_operator_email: certificate[41],
        old_certificate_serial_no: certificate[42],
        certificate_replace_mail_flag: certificate[43],
        download_method: certificate[44],
        last_updated: certificate[45]
      )
    end
  end
end
