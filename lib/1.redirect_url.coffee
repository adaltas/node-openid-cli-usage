
###

Command:

npx openid-cli-usage redirect_url \
  --authorization_endpoint http://127.0.0.1:5556/dex/auth \
  --client_id example-app \
  --redirect_uri http://127.0.0.1:5555/callback \
  --scope openid \
  --scope email \
  --scope offline_access

Prints:

code_verifier: jVc-dP1YsCFp6px0XKFHBMtM5lwfp2inbb9xE8iv3y8
url:           http://127.0.0.1:5556/dex/auth?client_id=example-app&scope=openid%20email%20offline_access&response_type=code&redirect_uri=http://localhost:3002/auth/callback&code_challenge=I-bxiEvqV5NOveieEt2RWC1-pwknOg8UCa2FMi0Supg&code_challenge_method=S256

###

crypto = require 'crypto'

base64URLEncode = (str) ->
  str.toString('base64')
    .replace(/\+/g, '-')
    .replace(/\//g, '_')
    .replace(/=/g, '');

sha256 = (buffer) ->
  crypto
    .createHash('sha256')
    .update(buffer)
    .digest()

app =
  name: 'redirect_url'
  description: 'OAuth2 and OIDC usage - step 1 - redirect URL generation.'
  options:
    client_id:
      description: 'Client ID', required: true
    authorization_endpoint:
      description: 'Authorization endpoint.', required: true
    redirect_uri:
      description: 'Redirect URI.', required: true
    scope:
      type: 'array', required: true
      description: 'Scopes such as "openid", "email", "offline_access"'
  handler: ({
    params: { authorization_endpoint, client_id, redirect_uri, scope }
    stdout
  }) ->
    code_verifier = base64URLEncode(crypto.randomBytes(32))
    code_challenge = base64URLEncode(sha256(code_verifier))
    url = [
      "#{authorization_endpoint}?"
      "client_id=#{client_id}&"
      "scope=#{scope.join '%20'}&"
      "response_type=code&"
      "redirect_uri=#{redirect_uri}&"
      "code_challenge=#{code_challenge}&"
      "code_challenge_method=S256"
    ].join ''
    data =
      code_verifier: code_verifier
      url: url
    stdout.write JSON.stringify data, null, 2
    stdout.write '\n\n'

if require.main is module
  require('parameters')(app).route()
else
  module.exports = app
