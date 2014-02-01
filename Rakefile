require 'rake'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.name = 'test'
  t.libs.push "spec"
  t.libs.push "spec/fixture"
  t.verbose = true
  t.warning = true
  t.test_files = FileList['spec/*_spec.rb']
end
