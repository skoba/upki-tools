# coding: utf-8
require 'rails_helper'

RSpec.describe CertificatesController, type: :request do
  
  # Security Tests - TDD Red Phase
  describe 'security requirements' do
    let(:valid_attributes_with_passphrase) do
      {
        operator_fqdn: 'test.example.com',
        operator_name: 'Test User',
        operator_affiliation: 'Test Organization',
        operator_email: 'test@example.com',
        operator_software: 'Apache 2.4',
        passphrase: 'secret123'
      }
    end

    it 'should not save passphrase to database when creating certificate' do
      expect {
        post certificates_path, params: { certificate: valid_attributes_with_passphrase }
      }.not_to change(Certificate, :count) # create doesn't save to DB anyway
      
      # If any certificate was created, it should not have passphrase stored
      if Certificate.exists?
        certificates = Certificate.all
        certificates.each do |cert|
          expect { cert.passphrase }.to raise_error(NoMethodError)
        end
      end
    end
    
    it 'should not save private key to database' do
      certificate = create(:certificate)
      patch certificate_path(certificate), params: { certificate: valid_attributes_with_passphrase }
      
      certificate.reload
      expect { certificate.private_key }.to raise_error(NoMethodError)
      expect { certificate.cipher_key_stored }.to raise_error(NoMethodError)
    end
  end
  describe 'GET /certificates' do
    it 'returns a successful response' do
      get certificates_path
      expect(response).to have_http_status(:ok)
    end
    
    context 'when certificates exist' do
      let!(:certificate) { create(:certificate) }
      
      it 'displays certificates' do
        get certificates_path
        expect(response.body).to include(certificate.operator_fqdn)
      end
    end
  end

  describe 'GET /certificates/new' do
    it 'returns a successful response' do
      get new_certificate_path
      expect(response).to have_http_status(:ok)
    end
    
    it 'assigns a new certificate' do
      get new_certificate_path
      expect(assigns(:certificate)).to be_a_new(Certificate)
    end
  end

  describe 'POST /certificates' do
    let(:valid_attributes) do
      {
        operator_fqdn: 'test.example.com',
        operator_name: 'Test User',
        operator_affiliation: 'Test Organization',
        operator_email: 'test@example.com',
        operator_software: 'Apache 2.4',
        passphrase: 'test123'
      }
    end

    let(:invalid_attributes) do
      {
        operator_fqdn: '',
        operator_email: '',
        operator_software: ''
      }
    end

    context 'with valid parameters' do
      it 'creates a new Certificate and downloads ZIP file' do
        post certificates_path, params: { certificate: valid_attributes }
        
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/zip')
        expect(response.headers['Content-Disposition']).to include('attachment')
        expect(response.headers['Content-Disposition']).to include('test.example.com.zip')
      end
      
      it 'does not save certificate to database' do
        expect {
          post certificates_path, params: { certificate: valid_attributes }
        }.not_to change(Certificate, :count)
      end
    end

    context 'with invalid parameters' do
      it 'renders the new template with errors' do
        post certificates_path, params: { certificate: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('prohibited this certificate from being saved')
      end
    end
  end

  describe 'GET /certificates/:id' do
    let(:certificate) { create(:certificate) }
    
    it 'returns a successful response' do
      get certificate_path(certificate)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /certificates/:id/edit' do
    let(:certificate) { create(:certificate) }
    
    it 'returns a successful response' do
      get edit_certificate_path(certificate)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PATCH /certificates/:id' do
    let(:certificate) { create(:certificate) }
    
    let(:valid_update_attributes) do
      {
        operator_name: 'Updated Name',
        operator_email: 'updated@example.com',
        operator_software: 'Updated Software',
        passphrase: 'newpass123'
      }
    end

    let(:invalid_update_attributes) do
      {
        operator_fqdn: '',
        operator_email: '',
        operator_software: ''
      }
    end

    context 'with valid parameters' do
      it 'updates the certificate and downloads ZIP file' do
        patch certificate_path(certificate), params: { certificate: valid_update_attributes }
        
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/zip')
        expect(response.headers['Content-Disposition']).to include('attachment')
        
        certificate.reload
        expect(certificate.operator_name).to eq('Updated Name')
        expect(certificate.operator_email).to eq('updated@example.com')
      end
    end

    context 'with invalid parameters' do
      it 'renders the edit template with errors' do
        patch certificate_path(certificate), params: { certificate: invalid_update_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('prohibited this certificate from being saved')
      end
    end
  end

  describe 'POST /certificates/:id/revoke' do
    let(:certificate) { create(:certificate) }
    
    let(:revoke_attributes) do
      {
        revocation_reason_code: 5,
        revocation_reason: 'Server decommissioned'
      }
    end

    it 'generates revocation TSV file' do
      post revoke_certificate_path(certificate), params: { certificate: revoke_attributes }
      
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('text/plain')
      expect(response.headers['Content-Disposition']).to include('attachment')
      expect(response.headers['Content-Disposition']).to include("#{certificate.operator_fqdn}.tsv")
    end
  end

  describe 'file operations' do
    let(:valid_attributes) do
      {
        operator_fqdn: 'test.example.com',
        operator_name: 'Test User',
        operator_affiliation: 'Test Organization', 
        operator_email: 'test@example.com',
        operator_software: 'Apache 2.4',
        passphrase: 'test123'
      }
    end

    it 'cleans up temporary files after download' do
      post certificates_path, params: { certificate: valid_attributes }
      
      # Check that no temporary files are left behind
      temp_files = Dir.glob(Rails.root.join('tmp', 'test.example.com.*'))
      expect(temp_files).to be_empty
    end
  end
end