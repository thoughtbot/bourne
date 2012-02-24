require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rake/testtask'

desc "Run all tests"
task 'default' => ['test:units', 'test:acceptance', 'test:performance']

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

  desc "Run performance tests"
  task 'performance' do
    require File.join(File.dirname(__FILE__), 'test', 'acceptance', 'stubba_example_test')
    require File.join(File.dirname(__FILE__), 'test', 'acceptance', 'mocha_example_test')
    iterations = 1000
    puts "\nBenchmarking with #{iterations} iterations..."
    [MochaExampleTest, StubbaExampleTest].each do |test_case|
      puts "#{test_case}: #{benchmark_test_case(test_case, iterations)} seconds."
    end
  end
end

def benchmark_test_case(klass, iterations)
  require 'benchmark'

  if defined?(MiniTest)
    MiniTest::Unit.output = StringIO.new
    Benchmark.realtime { iterations.times { |i| MiniTest::Unit.new.run([klass]) } }
  else
    load 'test/unit/ui/console/testrunner.rb' unless defined?(Test::Unit::UI::Console::TestRunner)
    unless $silent_option
      begin
        load 'test/unit/ui/console/outputlevel.rb' unless defined?(Test::Unit::UI::Console::OutputLevel::SILENT)
        $silent_option = { :output_level => Test::Unit::UI::Console::OutputLevel::SILENT }
      rescue LoadError
        $silent_option = Test::Unit::UI::SILENT
      end
    end
    Benchmark.realtime { iterations.times { Test::Unit::UI::Console::TestRunner.run(klass, $silent_option) } }
  end
end
