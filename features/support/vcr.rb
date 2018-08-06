require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'features/vcr_cassettes'
  c.ignore_hosts '127.0.0.1', 'localhost'
  c.hook_into :webmock
end

VCR.cucumber_tags do |t|
  t.tag  '@stripe_request', record: :new_episodes
end
