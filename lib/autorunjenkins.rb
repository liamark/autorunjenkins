require "autorunjenkins/version"

module Autorunjenkins
  require "net/http"
require "uri"
require "json"

# This script allows a user to automatically run jenkins jobs from the cmd line.
# It makes use of the jenkins build token feature and JSON
# responses to kick off and report on the builds progress
# Fill in all fields below before running the script.

# editable fields directing to users job
jenkins_url = "Replace me" # IP or domain of your jenkins host
jenkins_port = "Replace me" # Port number for http access e.g 8080
user_job = "Replcae me" # name of job as seen in jenkins
user_token = "Replace me" # build token from above job
user_id = "Replace me" # your jenkins username
user_apikey = "Replace me" # your jenkins API key

str = "http://jenkins_url:jenkins_port/job/user_job/build?token=user_token"
str.sub! "jenkins_url", jenkins_url
str.sub! "jenkins_port", jenkins_port
str.sub! "user_job", user_job
str.sub! "user_token", user_token
uri = URI.parse(str)

# Get request
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Get.new(uri.request_uri)
request.basic_auth(user_id, user_apikey)
response = http.request(request)

# process url to hit api json response
location = response.get_fields("location")
location = location.to_s
location = location.tr('[]', '')
location = location.tr('\"', '')
location = location.gsub(/$/, 'api/json')
puts location

# Check build queue for executor number value to confirm build progree
uri = URI(location)
request = Net::HTTP.get(uri)
firsthash = JSON.parse(request)
fkeys = firsthash.keys
$fincluded = fkeys.include? ('executable')
while $fincluded == false
  sleep(2)
  puts "building"
  response = Net::HTTP.get(uri)
  firsthash =JSON.parse(response)
  fkeys = firsthash.keys
  $fincluded = fkeys.include? ('executable')
end
numb = firsthash["executable"]["number"]
puts "build number = #{numb}"

# call build number url to confirm completion
str.sub! "build?token=", numb.to_s
str.sub! user_token, "/api/json"
uri = URI(str)
request = Net::HTTP::Get.new(uri)
request.basic_auth(user_id, user_apikey)
response = Net::HTTP.start(uri.hostname, uri.port) do |http|
  http.request(request)
end
secondhash = JSON.parse(response.body) #
skeys = secondhash.keys
$sincluded = skeys.include? ('result')
while $sinclude == false
  puts "building"
  response = Net::HTTP.get(uri)
  secondhash =JSON.parse(response)
  skeys = secondhash.keys
  $sincluded = skeys.include? ('result')
end
result = secondhash["result"]
puts "Done: #{result}".
end
