#
# Query a Pinecone index
#

require 'json'
require 'net/http'
require 'uri'

# CHANGEME
index_host = 'CHANGEME.pinecone.io'
api_key = 'CHANGEME'

url = URI("https://#{index_host}/query")
http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true

request = Net::HTTP::Post.new(url)
request["accept"] = 'application/json'
request["content-type"] = 'application/json'
request["Api-Key"] = api_key

vector = [0, 0, 1, 0, 0, 0, 0, 7, 21, 55, 125, 127, 117, 138, 122, 108, 123, 129, 103, 102, 119, 120, 67, 26, 0, 0, 0, 0, 0, 0, 0, 26, 127, 153, 181, 200, 204, 201, 201, 200, 203, 208, 205, 203, 207, 206, 230, 205, 205, 204, 200, 194, 165, 35, 0, 0, 0, 0, 0, 180, 218, 193, 186, 174, 170, 164, 141, 149, 142, 155, 168, 170, 161, 151, 157, 162, 166, 159, 165, 171, 189, 200, 4, 0, 0, 0, 120, 202, 166, 172, 175, 175, 171, 161, 176, 169, 155, 158, 171, 168, 162, 161, 157, 164, 187, 175, 162, 143, 140, 194, 87, 0, 0, 0, 188, 194, 169, 176, 166, 162, 163, 158, 165, 174, 159, 152, 164, 163, 160, 160, 157, 155, 174, 181, 178, 155, 144, 179, 178, 0, 0, 0, 202, 198, 172, 181, 175, 179, 182, 178, 175, 184, 171, 161, 170, 168, 167, 168, 169, 161, 166, 172, 175, 172, 149, 195, 201, 0, 0, 0, 198, 185, 164, 159, 160, 163, 162, 164, 157, 165, 167, 159, 163, 159, 157, 154, 156, 154, 147, 148, 144, 155, 133, 151, 199, 0, 0, 0, 154, 199, 189, 160, 155, 161, 165, 175, 166, 163, 168, 164, 165, 164, 163, 163, 157, 152, 156, 155, 149, 170, 168, 163, 167, 0, 0, 0, 145, 210, 208, 202, 156, 166, 149, 168, 182, 170, 165, 168, 159, 163, 170, 159, 168, 161, 157, 172, 150, 163, 195, 194, 118, 0, 0, 0, 172, 192, 176, 193, 158, 165, 165, 152, 161, 165, 154, 166, 153, 153, 157, 146, 164, 153, 157, 161, 147, 146, 180, 190, 125, 0, 0, 0, 139, 228, 175, 194, 188, 178, 182, 185, 177, 181, 172, 178, 174, 173, 173, 168, 174, 169, 175, 171, 173, 150, 130, 200, 163, 0, 0, 0, 138, 240, 0, 124, 255, 207, 207, 214, 217, 216, 216, 214, 215, 205, 205, 204, 204, 205, 202, 201, 201, 204, 194, 246, 49, 0, 0, 0, 121, 230, 92, 204, 209, 191, 195, 194, 194, 192, 188, 189, 188, 186, 188, 189, 190, 190, 189, 186, 185, 187, 174, 220, 120, 0, 0, 0, 66, 196, 158, 165, 174, 161, 161, 162, 160, 157, 152, 156, 154, 150, 149, 149, 150, 150, 148, 146, 140, 132, 123, 165, 172, 0, 0, 0, 168, 208, 89, 156, 212, 164, 175, 173, 173, 171, 166, 171, 170, 166, 164, 166, 165, 164, 161, 158, 152, 154, 147, 176, 126, 0, 0, 1, 186, 206, 156, 180, 178, 165, 166, 168, 168, 166, 164, 163, 160, 158, 160, 160, 164, 165, 160, 158, 154, 150, 136, 184, 119, 0, 0, 0, 151, 200, 168, 170, 168, 171, 167, 168, 170, 161, 165, 163, 164, 157, 150, 159, 159, 155, 155, 152, 154, 148, 134, 194, 94, 0, 0, 39, 211, 184, 167, 169, 166, 165, 170, 163, 169, 176, 170, 181, 177, 181, 167, 172, 180, 155, 154, 158, 153, 154, 133, 218, 124, 0, 0, 46, 183, 177, 173, 170, 166, 166, 165, 163, 169, 180, 159, 172, 170, 161, 174, 155, 174, 175, 152, 156, 157, 151, 132, 198, 107, 0, 0, 139, 155, 179, 158, 170, 169, 168, 167, 164, 170, 175, 164, 163, 169, 167, 165, 173, 163, 173, 157, 159, 157, 148, 140, 209, 99, 0, 0, 176, 182, 174, 161, 166, 166, 166, 165, 160, 169, 172, 167, 167, 159, 171, 160, 158, 159, 160, 152, 159, 156, 149, 126, 204, 122, 0, 0, 150, 179, 162, 164, 168, 166, 167, 166, 161, 167, 173, 170, 170, 167, 178, 168, 157, 176, 164, 148, 156, 155, 146, 131, 230, 108, 0, 0, 154, 198, 166, 164, 167, 165, 165, 166, 162, 162, 170, 175, 170, 159, 171, 166, 158, 165, 164, 152, 153, 150, 151, 137, 240, 84, 0, 0, 131, 179, 174, 158, 167, 165, 165, 166, 163, 162, 169, 175, 170, 160, 176, 160, 174, 168, 173, 158, 155, 153, 151, 132, 223, 128, 0, 0, 136, 151, 178, 156, 169, 165, 165, 168, 163, 161, 167, 174, 161, 157, 175, 155, 167, 159, 165, 150, 154, 154, 146, 148, 178, 142, 0, 0, 127, 120, 183, 157, 166, 166, 162, 162, 164, 165, 168, 173, 172, 166, 171, 174, 165, 165, 162, 158, 156, 146, 136, 174, 167, 164, 0, 0, 0, 59, 197, 168, 176, 173, 178, 175, 173, 179, 183, 184, 181, 176, 178, 179, 179, 181, 183, 187, 185, 188, 172, 151, 179, 153, 0, 0, 0, 31, 174, 179, 168, 155, 170, 182, 167, 162, 155, 154, 164, 161, 158, 162, 160, 160, 161, 152, 158, 170, 181, 144, 149, 29, 0]

request.body =  {
          "vector": vector,
          "topK": 10,
          "includeMetadata": false,
          "includeValues": false
        }.to_json



starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)

response = http.request(request)

ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)

puts response.read_body
puts
puts "Query response in #{(ending - starting) * 1000} milliseconds"