require File.dirname(__FILE__) + "/signature_validator"

use Rack::SignatureValidator, 'our-secret-key'
run Proc.new { |env| [200, {"Content-Type" => "text/html"}, ["Hello World! from Signature\n"]] }
