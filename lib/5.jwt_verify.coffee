
###

Command:

npx openid-cli-usage jwt_verify \
  --token eyJhbGciOiJSUzI1NiIsImtpZCI6IjgzYmI1ZTEyYmRlOTk3MWQ2ODgzMjU0MDA1NWI5ZjViN2NkZmIyYjYifQ.eyJpc3MiOiJodHRwOi8vMTI3LjAuMC4xOjU1NTYvZGV4Iiwic3ViIjoiQ2dVME5qZzVOaElHWjJsMGFIVmkiLCJhdWQiOiJ3ZWJ0ZWNoLWF1dGgiLCJleHAiOjE2MDU2ODk4NDMsImlhdCI6MTYwNTYwMzQ0MywiYXRfaGFzaCI6IkNvcG92X01aOEo2Wmk2c0NwRTlPaHciLCJlbWFpbCI6ImRhdmlkQGFkYWx0YXMuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWV9.A5Mz37rKLw8PbdB_9DJ6YGqEydvTe53a1Z8TMaNWUoaYz9tgFiQW_6gIJBX8ivmqoFVS-9ydbaTTomr64ZL6LtFtSl50jigJ5nBxpZv4_SXkCF0EphjoOmAvTX5HhCep_ig0QGwUamKGVzo5EeSqEK9jpH3nb2Hlt9AKjn4aShsWdrwiHz2FLHFdLlUfzSG113yDCvyoTP7JWONanSveLhDvEY3zlAlwY9auDVZqnnJsRatGbzWu1-gpAM9bZD6DgzMLnYyIaLH1yHtSgXOd748rTk4vOcvHRitSew_oZoVpcX17V0D2Fmk87tMKMnEgKARdcv5MKPH5YWpsZIkNbQ \
  --jwks_uri http://127.0.0.1:5556/dex/keys

Prints on success:

{
  "iss": "http://127.0.0.1:5556/dex",
  "sub": "CgU0Njg5NhIGZ2l0aHVi",
  "aud": "example-app",
  "exp": 1605689843,
  "iat": 1605603443,
  "at_hash": "Copov_MZ8J6Zi6sCpE9Ohw",
  "email": "david@adaltas.com",
  "email_verified": true
}

Prints on error:

invalid signature

###



jwt = require 'jsonwebtoken'
jwksClient = require 'jwks-rsa'

app =
  name: 'jwt_verify'
  description: 'OAuth2 and OIDC usage - step 5 - JWT verification.'
  options:
    jwks_uri:
      description: 'Keys endpoint storing JSON Web Keys (JWK).', required: true
    token:
      description: 'JWT token.', required: true
  handler: ({
    params: { jwks_uri, token }
    stdout
    stderr
  }) ->
    try
      # Extract the header
      header = JSON.parse Buffer.from(
        token.split('.')[0], 'base64'
      ).toString('utf-8')
      # Math the kid from JWKS and get the public key
      {publicKey, rsaPublicKey} = await jwksClient
        jwksUri: "#{jwks_uri}"
      .getSigningKeyAsync header.kid
      key = publicKey or rsaPublicKey
      # Validate the payload
      payload = jwt.verify token, key
      stdout.write JSON.stringify payload, null, 2
      stdout.write '\n\n'
    catch err
      stderr.write err.message
      stderr.write '\n\n'

if require.main is module
  require('parameters')(app).route()
else
  module.exports = app
