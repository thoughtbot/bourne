require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rake/testtask'

desc "Run all tests"
task 'default' => ['test:units', 'test:acceptance']

namespace 'test' do
  unit_tests       = FileList['test/unit/**/*_test.rb']
  acceptance_tests = FileList['test/acceptance/*_test.rb']

  desc "Run unit tests"
  Rake::TestTask.new('units') do |t|
    t.libs << 'test'
    t.test_files = unit_tests
  end

  desc "Run acceptance tests"
  Rake::TestTask.new('acceptance') do |t|
    t.libs << 'test'
    t.test_files = acceptance_tests
  end

end
