
###

Command:

coffee bin/3.refresh_token.coffee \
  --client_id webtech-auth \
  --client_secret ZXhhbXBsZS1hcHAtc2VjcmV1 \
  --token_endpoint http://127.0.0.1:5556/dex/token \
  --refresh_token Chlhb2t4N20yaGVwcTJpMzY2Mm94cmhkdDJhEhl3aXp3MzJjYzdoajd6Nnhmd2V5amJ4czJo

Print on success:

{
  "access_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjgzYmI1ZTEyYmRlOTk3MWQ2ODgzMjU0MDA1NWI5ZjViN2NkZmIyYjYifQ.eyJpc3MiOiJodHRwOi8vMTI3LjAuMC4xOjU1NTYvZGV4Iiwic3ViIjoiQ2dVME5qZzVOaElHWjJsMGFIVmkiLCJhdWQiOiJ3ZWJ0ZWNoLWF1dGgiLCJleHAiOjE2MDU2ODk4NDMsImlhdCI6MTYwNTYwMzQ0MywiYXRfaGFzaCI6IkNvcG92X01aOEo2Wmk2c0NwRTlPaHciLCJlbWFpbCI6ImRhdmlkQGFkYWx0YXMuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWV9.A5Mz37rKLw8PbdB_9DJ6YGqEydvTe53a1Z8TMaNWUoaYz9tgFiQW_6gIJBX8ivmqoFVS-9ydbaTTomr64ZL6LtFtSl50jigJ5nBxpZv4_SXkCF0EphjoOmAvTX5HhCep_ig0QGwUamKGVzo5EeSqEK9jpH3nb2Hlt9AKjn4aShsWdrwiHz2FLHFdLlUfzSG113yDCvyoTP7JWONanSveLhDvEY3zlAlwY9auDVZqnnJsRatGbzWu1-gpAM9bZD6DgzMLnYyIaLH1yHtSgXOd748rTk4vOcvHRitSew_oZoVpcX17V0D2Fmk87tMKMnEgKARdcv5MKPH5YWpsZIkNbQ",
  "token_type": "bearer",
  "expires_in": 86399,
  "refresh_token": "Chlhb2t4N20yaGVwcTJpMzY2Mm94cmhkdDJhEhlmcTRuM2Z4d3g2bGFxd20ydm9vc2pmamR1",
  "id_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjgzYmI1ZTEyYmRlOTk3MWQ2ODgzMjU0MDA1NWI5ZjViN2NkZmIyYjYifQ.eyJpc3MiOiJodHRwOi8vMTI3LjAuMC4xOjU1NTYvZGV4Iiwic3ViIjoiQ2dVME5qZzVOaElHWjJsMGFIVmkiLCJhdWQiOiJ3ZWJ0ZWNoLWF1dGgiLCJleHAiOjE2MDU2ODk4NDMsImlhdCI6MTYwNTYwMzQ0MywiYXRfaGFzaCI6Ikc4SUxKbXZ3N3lwRDZtYzZLZXhscEEiLCJlbWFpbCI6ImRhdmlkQGFkYWx0YXMuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWV9.WKrYxJFkPiJ4v4P3DgT9B7Hf10Rg037FJwfU_8vKsZiOjHC7GFRMs6M25NkBSRZjPlupKkLhsDztYq4w5Yveo3izo1m4oVOg1N24KZ5kTdTtIP_cRM9cd9820mIQGmRLIc2i-PFMpC37wRybpUEWWZNM5VRceCE6aeyXIzPw_RBxI5pg4JUSTkXJMOxRE31mRxpC1T9hg0PHPc4jClGua6hGM7BtlcMvT0uDnt84JFi-FrrKyHF3QuoPxk2Y6WZER5m1R3Ndn8ItkGwNyg8bcnossYK0WsIKmoHw8p8oYzpwEMEd1bhkUxg3yTWGL1-e0OELt71Jbo4D_o18J4rKwA"
}

Print on error:

{
  "error": "invalid_request",
  "error_description": "Refresh token is invalid or has already been claimed by another client."
}

###

axios = require 'axios'
qs = require 'qs'

app =
  name: 'refresh_token'
  description: 'OAuth2 and OIDC usage - step 3 - refresh token grant'
  options:
    client_id:
      description: 'Client ID', required: true
    client_secret:
      description: 'Client secret'
    refresh_token:
      description: 'Refresh token', required: true
    token_endpoint:
      description: 'Token endpoint', required: true
  handler: ({
    params: { client_id, client_secret, refresh_token, token_endpoint }
    stdout
    stderr
  }) ->
    try
      {data} = await axios.post token_endpoint,
        qs.stringify
          grant_type: 'refresh_token'
          client_id: client_id
          client_secret: client_secret
          refresh_token: refresh_token
      stdout.write """
      
      #{JSON.stringify data, null, 2}
      
      
      """
    catch err
      stderr.write """
      
      #{JSON.stringify err.response.data, null, 2}
      
      
      """

if require.main is module
  require('parameters')(app).route()
else
  module.exports = app
