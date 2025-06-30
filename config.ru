#RAILS_RELATIVE_URL_ROOT="/upki"
require ::File.expand_path('../config/environment',  __FILE__)
if ENV['RAILS_RELATIVE_URL_ROOT'] then
        map ENV['RAILS_RELATIVE_URL_ROOT'] do
                run Rails.application
        end
else
        run Rails.application
end

