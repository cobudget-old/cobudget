When /^(.*) an error should be raised$/ do |original_step|
  expect {
    step(original_step)
  }.to raise_error() { |error|
    raise error if error.class.name.starts_with?('Cucumber::') || error.class.name.starts_with?('RSpec::')
  }
end

When /^(.*) an error should not be raised$/ do |original_step|
  step(original_step)
end