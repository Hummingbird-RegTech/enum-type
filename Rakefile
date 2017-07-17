desc 'Run test suite'
task :test do
  puts 'Running Rubocop...'
  sh('rubocop')
  puts 'Running RSpec...'
  sh('rspec')
end

task default: [:test]
