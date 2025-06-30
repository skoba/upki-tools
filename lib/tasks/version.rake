# frozen_string_literal: true

namespace :version do
  desc "Display current application version"
  task :show do
    puts "UPKI Certificate Management System v#{UpkiTools::Application::VERSION}"
  end

  desc "Create git tag for current version"
  task :tag do
    version = UpkiTools::Application::VERSION
    tag_name = "v#{version}"
    
    puts "Creating git tag: #{tag_name}"
    system("git tag -a #{tag_name} -m 'Release version #{version}'")
    
    if $?.success?
      puts "✅ Tag #{tag_name} created successfully"
      puts "To push the tag to remote:"
      puts "  git push origin #{tag_name}"
    else
      puts "❌ Failed to create tag"
    end
  end

  desc "Show git tags"
  task :tags do
    puts "Git tags:"
    system("git tag -l")
  end
end