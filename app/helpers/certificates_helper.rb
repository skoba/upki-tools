module CertificatesHelper
  def certificate_color(certificate)
    if certificate.revocation_completed
      'table-dark'
    elsif certificate.cert_exp
      if certificate.cert_exp < Time.now
        'table-danger'
      elsif certificate.cert_exp < Time.now.next_month
        'table-warning'
      else
        'table-success'
      end
    else
      'table-success'
    end
  end

  def update_button_class(certificate)
    if certificate.revocation_completed
      'btn disabled'
    else
      'btn btn-primary'
    end
  end

  def delete_button_class(certificate)
    if certificate.revocation_completed
      'btn disabled'
    else
      'btn btn-danger'
    end
  end

end
