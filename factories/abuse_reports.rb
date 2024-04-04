require 'faker'
FactoryBot.define do
  factory :abuse_report do
    email { "me@example.com" }
    url { "http://archiveofourown.org/tags/2000%20AD%20(Comics)/works" }
    comment { "bla blablalba" }
    summary { "less" }
    language { "Francais" }
  end
end
