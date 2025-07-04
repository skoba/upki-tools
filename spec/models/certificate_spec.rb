# coding: utf-8
require 'rails_helper'
require 'csv'

RSpec.describe Certificate, type: :model do
  let(:certificate) { create :certificate }
  subject { certificate }

  # Validations
  describe 'validations' do
    it { is_expected.to validate_presence_of(:operator_fqdn) }
    it { is_expected.to validate_presence_of(:operator_email) }
    it { is_expected.to validate_presence_of(:operator_software) }
  end

  # Security Tests - TDD Red Phase
  describe 'security requirements' do
    it 'should not have passphrase column in database' do
      expect(Certificate.column_names).not_to include('passphrase')
    end
    
    it 'should not have private_key column in database' do
      expect(Certificate.column_names).not_to include('private_key')
    end
    
    it 'should not have cipher_key column in database' do
      expect(Certificate.column_names).not_to include('cipher_key')
    end
    
    it 'should not persist passphrase to database' do
      cert = Certificate.new(operator_fqdn: 'test.example.com', 
                           operator_email: 'test@example.com',
                           operator_software: 'nginx')
      
      # パスフレーズ属性が存在しないことを確認
      expect { cert.passphrase = 'secret123' }.to raise_error(NoMethodError)
    end
    
    it 'should not persist private key to database' do
      cert = Certificate.new(operator_fqdn: 'test.example.com',
                           operator_email: 'test@example.com', 
                           operator_software: 'nginx')
      
      # 秘密鍵属性が存在しないことを確認
      expect { cert.private_key = 'some_key' }.to raise_error(NoMethodError)
    end
  end

  its(:dn) { is_expected.to eq 'CN=test.medical-oss.org,O=医療オープンソースソフトウェア協議会,L=Tokyo,ST=Tokyo,C=JP' }

  its(:dn2entries) { is_expected.to match_array [['CN', 'test.medical-oss.org'],['O','医療オープンソースソフトウェア協議会'],['L','Tokyo'],['ST','Tokyo'],['C','JP']]}
      
  describe '#create' do
    it 'create cipher key' do
      # OpenSSL 3.0+ uses "Private-Key" instead of "RSA Private-Key"
      expect(certificate.cipher_key.to_text).to start_with('Private-Key: (2048 bit').or start_with('RSA Private-Key: (2048 bit')
    end

    it 'create csr' do
      expect(certificate.csr_main).to start_with 'MIIC'
    end
    
    it 'generates encrypted private key with passphrase' do
      passphrase = 'test_passphrase'
      encrypted_key = certificate.cipher_key_pem(passphrase)
      expect(encrypted_key).to include('-----BEGIN RSA PRIVATE KEY-----').or include('-----BEGIN ENCRYPTED PRIVATE KEY-----')
      expect(encrypted_key).to include('-----END RSA PRIVATE KEY-----').or include('-----END ENCRYPTED PRIVATE KEY-----')
      expect(encrypted_key).to include('Proc-Type: 4,ENCRYPTED').or include('ENCRYPTED')
    end
    
    it 'generates unencrypted private key without passphrase' do
      unencrypted_key = certificate.cipher_key_pem
      expect(unencrypted_key).to include('-----BEGIN RSA PRIVATE KEY-----').or include('-----BEGIN PRIVATE KEY-----')
      expect(unencrypted_key).to include('-----END RSA PRIVATE KEY-----').or include('-----END PRIVATE KEY-----')
    end

   it 'get default operator name from profile' do
     expect(certificate.operator_name).to eq 'KOBAYASHI Shinji'
   end

   it 'get default operator email from profile' do
     expect(certificate.operator_email).to eq 'skoba@moss.gr.jp'
   end

   it 'assign software name' do
     expect(certificate.operator_software).to eq 'nginx 1.18.0'
   end

    describe 'tsv' do
      let(:tsv) { certificate.new_tsv }

      it 'create tsv' do
        expect(tsv).not_to be_empty
      end

      describe 'parameters in tsv' do
        subject { ->(n) { tsv.split("\t")[n-1] } }
        
        its( [1]) { is_expected.to eq 'CN=test.medical-oss.org,O=医療オープンソースソフトウェア協議会,L=Tokyo,ST=Tokyo,C=JP' }
        its( [2]) { is_expected.to eq '3' }
        its( [3]) { is_expected.to be_empty }
        its( [4]) { is_expected.to be_empty }
        its( [5]) { is_expected.to be_empty }
        its( [6]) { is_expected.to be_empty }
        its( [7]) { is_expected.to start_with 'MIIC' }
        its( [8]) { is_expected.to eq 'KOBAYASHI Shinji' }
        its( [9]) { is_expected.to eq '医療オープンソースソフトウェア協議会' }
        its([10]) { is_expected.to eq 'skoba@moss.gr.jp' }
        its([11]) { is_expected.to eq 'test.medical-oss.org' }
        its([12]) { is_expected.to eq 'nginx 1.18.0' }
        its([13]) { is_expected.to eq "\n"}
      end
    end
  end

  describe '#update' do
    let(:tsv) { tsv = create :certificate; tsv.update_tsv }
    
    describe 'generate tsv file' do
      it 'create tsv' do
        expect(tsv).not_to be_empty
      end

      describe 'parameters in tsv' do
        subject { ->(n) { tsv.split("\t")[n-1] } }
        
        its( [1]) { is_expected.to eq 'CN=test.medical-oss.org,O=医療オープンソースソフトウェア協議会,L=Tokyo,ST=Tokyo,C=JP' }
        its( [2]) { is_expected.to eq '3' }
        its( [3]) { is_expected.to be_empty }
        its( [4]) { is_expected.to eq '2523387705629275603' }
        its( [5]) { is_expected.to be_empty }
        its( [6]) { is_expected.to be_empty }
        its( [7]) { is_expected.to start_with 'MIIC' }
        its( [8]) { is_expected.to eq 'KOBAYASHI Shinji' }
        its( [9]) { is_expected.to eq '医療オープンソースソフトウェア協議会' }
        its([10]) { is_expected.to eq 'skoba@moss.gr.jp' }
        its([11]) { is_expected.to eq 'test.medical-oss.org' }
        its([12]) { is_expected.to eq 'nginx 1.18.0' }
        its([13]) { is_expected.to eq "\n"}
      end
    end
  end

  describe '#destroy' do
    let(:tsv) { tsv = create :certificate; tsv.revoke_tsv }

    describe 'generate tsv file' do
      it 'is not empty' do
        expect(tsv).not_to be_empty
      end

    
      describe 'parameters in tsv' do
        subject { ->(n) { tsv.split("\t")[n-1] } }
      
        its( [1]) { is_expected.to eq 'CN=test.medical-oss.org,O=医療オープンソースソフトウェア協議会,L=Tokyo,ST=Tokyo,C=JP' }
        its( [2]) { is_expected.to be_empty }
        its( [3]) { is_expected.to be_empty }
        its( [4]) { is_expected.to eq '2523387705629275603' }
        its( [5]) { is_expected.to eq '5' }
        its( [6]) { is_expected.to eq 'サーバ使用中止' }
        its( [7]) { is_expected.to be_empty }
        its( [8]) { is_expected.to be_empty }
        its( [9]) { is_expected.to be_empty }
        its([10]) { is_expected.to eq 'skoba@moss.gr.jp' }
        its([11]) { is_expected.to be_empty }
        its([12]) { is_expected.to be_empty }
        its([13]) { is_expected.to eq "\n"}
      end
    end
  end

  describe 'update all with TSV file' do
    let(:tsv_file) { Rails.root.join 'db', 'serverAll.tsv' }

    context 'when TSV file exists' do
      before do
        # Create a dummy TSV file for testing
        File.write(tsv_file, "apply_id\toperation_id\tignore_flag\tsubject_dn\tdomain_id\tsubmitted\tcompleted\toperator_id\tcategory\ttask_model\tprofile_id\tstatus\toperator_name\toperator_affiliation\toperator_email\toperator_fqdn\toperator_software\tcsr\tdnsname\tcomfirmed_items_flag\ttransaction_id\tapi_erro_code\tcetification\tserial_no\tfinger_print\tcert_start\tcert_exp\turl_exp\taccess_pin\tother_subject_address1\tother_subject_address2\trevocation_id\trevocation_operation_id\trevocation_submitted\trevocation_completed\trevocation_operator_id\trevocation_reason_code\trevocation_reason\trevocation_confirm_code\trevocation_transaction_id\trevocation_authority_error_code\trevocation_operator_email\told_certificate_serial_no\tcertificate_replace_mail_flag\tdownload_method\tlast_updated\n")
      end
      
      after do
        File.delete(tsv_file) if File.exist?(tsv_file)
      end

      it 'reads TSV file without error' do
        expect { Certificate.read_tsv tsv_file }.not_to raise_error
      end
    end

    context 'when TSV file does not exist' do
      it 'raises file not found error' do
        expect { Certificate.read_tsv tsv_file }.to raise_error(Errno::ENOENT)
      end
    end

    xit 'parses TSV file' do
      expect(Certificate.parse_tsv(tsv).size).to 45
    end

    it 'identifies certificate by apply_id'
    it 'updates certificates from TSV'
  end

  describe 'revoke multiple certificates' do
    it 'generates certificate lists from ids'
  end
end
