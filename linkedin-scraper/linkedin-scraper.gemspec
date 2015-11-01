# -*- encoding: utf-8 -*-
require File.expand_path('../lib/linkedin-scraper/version', __FILE__)
require File.expand_path('../lib/linkedin-scraper/profile', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Yatish Mehta']
  gem.description   = %q{Scrapes the LinkedIn profile using the public url }
  gem.summary       = %q{when a url of  public linkedin profile page is given it scrapes the entire page and converts into a accessible object}
  gem.homepage      = 'https://github.com/yatishmehta27/linkedin-scraper'
  gem.files         = ["Gemfile", "LICENSE", "README.md", "Rakefile", "bin/linkedin-scraper", "lib/linkedin-scraper.rb", "lib/linkedin-scraper/profile.rb", "lib/linkedin-scraper/version.rb", "linkedin-scraper.gemspec", "spec/fixtures/jeffweiner08.html", "spec/linkedin_scraper/profile_spec.rb", "spec/spec_helper.rb"]
  gem.executables   = ['linkedin-scraper']
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'linkedin-scraper'
  gem.require_paths = ['lib']
  gem.version       = Linkedin::Scraper::VERSION

  gem.license       = "MIT"

  gem.add_dependency 'mechanize', '~> 2'
  
  gem.add_development_dependency 'rspec', '~> 3'
  gem.add_development_dependency 'rake', '~> 10'
end
