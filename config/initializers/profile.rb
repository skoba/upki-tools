class Profile
  class << self
    def yaml
      @yaml ||= YAML.load(File.read("#{Rails.root}/config/profile.yml")) #[Rails.env]
    end

    def dn
      yaml['DN']
    end

    def c
      dn['C']
    end

    def st
      dn['ST']
    end

    def l
      dn['L']
    end

    def o
      dn['O']
    end

    def ou
      dn['OU']
    end

    def operator
      yaml['operator']
    end

    def name
      operator['name']
    end

    def email
      operator['email']
    end
  end
end
