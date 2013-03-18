require File.dirname(__FILE__) + "/hmac_signature"
require 'cgi'

 module Rack
   class SignatureValidator
     def initialize(app, secret)
       @app = app
       @secret = secret
       @signer = HmacSignature.new('our-secret-key')
     end

     def call(env)
       if signature_is_valid?(env)
         @app.call(env)
       else
         [401, {"Content-Type" => "text/html"}, ["Bad Signature"]]
       end
     end

     def signature_is_valid?(env)
       req = Rack::Request.new(env)
       verb = env["REQUEST_METHOD"]
       host = env["SERVER_NAME"]
       path = env["REQUEST_PATH"]
       time = req.params["time"]

       sig = CGI.unescape(env["HTTP_X_AUTH_SIG"]) if env["HTTP_X_AUTH_SIG"]
       sig == @signer.sign(verb, host, path, req.params)
     end
   end
 end
