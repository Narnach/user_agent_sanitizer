Gem::Specification.new do |s|
  # Project
  s.name         = 'user_agent_sanitizer'
  s.summary      = "Browser user agent sanitizer"
  s.description  = "Browser user agent sanitizer, with a focus on sanitizing mobile phone user agents to brand + model number"
  s.version      = '2.0.0'
  s.date         = '2012-07-11'
  s.platform     = Gem::Platform::RUBY
  s.authors      = ["Wes Oldenbeuving"]
  s.email        = "narnach@gmail.com"
  s.homepage     = "http://www.github.com/Narnach/user_agent_sanitizer"

  # Files
  s.require_path = "lib"
  s.files        = ['user_agent_sanitizer.gemspec', 'LICENSE', 'README.md', 'Rakefile', 'lib/user_agent_sanitizer.rb', 'spec/user_agent_sanitizer_spec.rb', 'spec/spec_helper.rb']
  s.test_files   = ['spec/user_agent_sanitizer_spec.rb']

  # rdoc
  s.has_rdoc         = true
  s.extra_rdoc_files = %w[ README.md LICENSE]
  s.rdoc_options << '--inline-source' << '--line-numbers' << '--main' << 'README.md'

  # Requirements
  s.required_ruby_version = ">= 1.9.3"
end
