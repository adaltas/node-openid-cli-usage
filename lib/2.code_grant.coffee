
###

Command:

coffee lib/2.code_grant.coffee \
  --client_id example-app \
  --client_secret ZXhhbXBsZS1hcHAtc2VjcmV0 \
  --token_endpoint http://127.0.0.1:5556/dex/token \
  --redirect_uri http://127.0.0.1:5555/callback \
  --code_verifier NV6hs7EwTGJc3-B61k96K-U-kBSX3hEhA7cASO_Gyho \
  --code xhe5ltqhbviwvs37yd3uij5ih

Prints on success:

{
  "access_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjgzYmI1ZTEyYmRlOTk3MWQ2ODgzMjU0MDA1NWI5ZjViN2NkZmIyYjYifQ.eyJpc3MiOiJodHRwOi8vMTI3LjAuMC4xOjU1NTYvZGV4Iiwic3ViIjoiQ2dVME5qZzVOaElHWjJsMGFIVmkiLCJhdWQiOiJ3ZWJ0ZWNoLWF1dGgiLCJleHAiOjE2MDU2ODkwODgsImlhdCI6MTYwNTYwMjY4OCwiYXRfaGFzaCI6ImJYLXpmSVlZZEtUaTE5Q1NNRmlGZkEiLCJlbWFpbCI6ImRhdmlkQGFkYWx0YXMuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWV9.bIJYsGTCYypH9NYmxgX-KWjSs3Et7bEFAEkFlJKHvcXfYWxCAVBp0KZD2xUMTVXRsRHCjgsioyxuFqShmLu0Nt9Et5jQs8XieuTJTt4EplYt2q2SXveDM1xCpXLfMSTf5qbJKvKCxOo-fXsZXxYirEqA2wMa-0rsFvj8jyJGANe6iF7fbMHnnSmwGknQmMA7wT2S9J_0s53ommtbdAWFE8f8KyqjpzOugp3DRArwQzrViPeBpWqgHT3zMIZG_m4-LAHt5zJtk4SpUZuTG_MYamSMzmK0JVxmhXZm-KjM2FnT9UqX73qc74iBBn27VB1SnUhBpdxKjeHmXdZQg31ROA",
  "token_type": "bearer",
  "expires_in": 86399,
  "refresh_token": "Chlhb2t4N20yaGVwcTJpMzY2Mm94cmhkdDJhEhl3aXp3MzJjYzdoajd6Nnhmd2V5amJ4czJo",
  "id_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjgzYmI1ZTEyYmRlOTk3MWQ2ODgzMjU0MDA1NWI5ZjViN2NkZmIyYjYifQ.eyJpc3MiOiJodHRwOi8vMTI3LjAuMC4xOjU1NTYvZGV4Iiwic3ViIjoiQ2dVME5qZzVOaElHWjJsMGFIVmkiLCJhdWQiOiJ3ZWJ0ZWNoLWF1dGgiLCJleHAiOjE2MDU2ODkwODgsImlhdCI6MTYwNTYwMjY4OCwiYXRfaGFzaCI6ImhJTEhaaHJjNHdENlJZSzRLaVdMUlEiLCJlbWFpbCI6ImRhdmlkQGFkYWx0YXMuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWV9.CU8zht_oqzCQ3-b9q9H7R2NbSN4V--uTvNUqvUpVFxKUfAC1J9Kc4RQYtnU-N0kJP4ZO-a4OCN31dDj-3hin1Wj3G2qoNeTQB6p3zveUYca_eEVI5cP1jcj-jUa4QNz-CCraWIoQwPdnqUjHiWY3kg-thEONvR6QFhrRMcP-YkDpFmgyjYqNE1iWOuZbRPi6b1TzWmiCQG2ucevmDE8XFv845f3h7-qFnj2wmkaBJ9gxyRyn_-sD-qfYlYzK9MwUToM5lIX5TLfuN4p5QVVqFLIdEDyTG3hFlk5LSu2dzimCgddeWbN1MJnVdjRQWc5Gpvi3qkXqSeWwGHyAdrj_LQ"
}

Prints on error:

{
  "error": "invalid_request",
  "error_description": "Invalid or expired code parameter."
}

###

qs = require 'qs'
axios = require 'axios'

app =
  name: 'code_grant'
  description: 'OAuth2 and OIDC usage - step 2 - authorization code grant'
  options:
    client_id:
      description: 'Client ID.', required: true
    client_secret:
      description: 'Client secret, disregard for PKCE.'
    token_endpoint:
      description: 'Token endpoint.', required: true
    redirect_uri:
      description: 'Redirect URI.', required: true
    code_verifier:
      description: 'Code verifier.', required: true
    code:
      description: 'Code returned by the AS.', required: true
  handler: ({
    params: {
      client_id, client_secret, token_endpoint,
      redirect_uri, code_verifier, code
    }
    stdout
    stderr
  }) ->
    try
      {data} = await axios.post token_endpoint,
        qs.stringify
          grant_type: 'authorization_code'
          client_id: "#{client_id}"
          redirect_uri: "#{redirect_uri}"
          client_secret: client_secret
          code_verifier: "#{code_verifier}"
          code: "#{code}"
      stdout.write JSON.stringify data, null, 2
      stdout.write '\n\n'
    catch err
      stderr.write JSON.stringify err.response.data, null, 2
      stdout.write '\n\n'

if require.main is module
  require('parameters')(app).route()
else
  module.exports = app
