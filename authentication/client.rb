require 'cgi'
require File.dirname(__FILE__) + '/hmac_signature'

verb = 'GET'
host = 'localhost'
path = '/'
query_params = {'user' => 'mat', 'tag' => 'ruby'}

unscaped_sig = HmacSignature.new('our-secret-key').sign(verb, host, path, query_params)
sig = CGI.escape(unscaped_sig)

query_string = query_params.map do |k, v|
  [CGI.escape(k), CGI.escape(v)].join("=")
end.join("&")

puts "without signature:"
system %Q|curl -i "http://localhost:9292/?#{query_string}"|

sleep 2
 
puts "\n\nwith signature:\n"
system %Q|curl -i -H "X-Auth-Sig:#{sig}" "http://localhost:9292/?#{query_string}"|
