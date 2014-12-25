module MyLetDeclarations
  extend RSpec::SharedContext

  let(:success) { 200 }
  let(:created) { 201 }
  let(:updated) { 204 }
  let(:forbidden) { 403 }
  let(:request_headers) { {
    "Accept" => "application/json",
    "Content-Type" => "application/json",
    "X-User-Token" => user.access_token,
    "X-User-Email" => user.email,
  } }
end
RSpec.configure { |c| c.include MyLetDeclarations }
