
path = require 'path'
util = require 'util'
{exec} = require 'child_process'
exec = util.promisify exec

describe 'redirect_url', ->
  
  it 'output json', ->
    {stdout, stderr} = await exec """
    bin/openid-cli-usage redirect_url \
      --authorization_endpoint http://127.0.0.1:5556/dex/auth \
      --client_id webtech-frontend \
      --redirect_uri http://127.0.0.1:3000/callback \
      --scope openid \
      --scope email \
      --scope offline_access
    """,
      cwd: path.dirname __dirname
    data = JSON.parse stdout
    console.log data
    data.should.match
      code_verifier: /^[\d\w-]+$/
      url: /^http:\/\/127\.0\.0\.1:5556\/dex\/auth\?/
