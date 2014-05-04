require 'cobudget/entities/bucket'

FactoryGirl.define do
  factory :bucket, class: Cobudget::Bucket do
    name 'Bucket'
    budget
  end
end
