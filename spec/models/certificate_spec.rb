# coding: utf-8
require 'rails_helper'
require 'csv'

RSpec.describe Certificate, type: :model do
  let(:certificate) { create :certificate }
  subject { certificate }

  its(:dn) { is_expected.to eq 'CN=test.medical-oss.org,O=医療オープンソースソフトウェア協議会,L=Tokyo,ST=Tokyo,C=JP' }

  its(:dn2entries) { is_expected.to match_array [['CN', 'test.medical-oss.org'],['O','医療オープンソースソフトウェア協議会'],['L','Tokyo'],['ST','Tokyo'],['C','JP']]}
      
  describe '#create' do
    it 'create cipher key' do
      expect(certificate.cipher_key.to_text).to start_with 'RSA Private-Key: (2048 bit,'
    end

    it 'create csr' do
      expect(certificate.csr_main).to start_with 'MIIC'
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

    it 'reads TSV file' do
      expect { Certificate.read_tsv tsv_file }.not_to raise_error
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
