Gem::Specification.new do |s|
  s.name        = 'jekyll_date_chart'
  s.version     = '0.0.1'
  s.date        = '2013-10-10'
  s.summary     = 'Jekyll Date Chart'
  s.description = 'Jekyll block that renders date line charts based on textile-formatted tables'
  s.authors     = ['GSI']
  s.email       = 'rubygems.org@groovy-skills.com'
  s.files       = Dir['lib/*'] + Dir['bin/*'] + Dir['vendor/**/*']
  s.homepage    = 'https://github.com/GSI/' + s.name
  s.license     = 'MIT'

	s.add_runtime_dependency 'thor', '~> 0.18', '>= 0.18.1'
	s.executables << s.name
end
