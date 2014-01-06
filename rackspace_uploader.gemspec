Gem::Specification.new do |s|
  s.name        = 'rackspace_uploader'
  s.version     = '0.0.2.alpha'
  s.date        = '2013-09-17'
  s.files       = ["lib/rackspace_uploader.rb"]
  s.authors     = ["Nathan Wenneker"]
  s.license       = 'MIT'
  s.summary     = "Simple wrapper for buffered file uploads to Rackspace container"
  s.add_dependency 'fog'
end