require 'spec_helper'
require 'webmock/rspec'

# Permit returning real responses
#WebMock.allow_net_connect!(:net_http_connect_on_start => true)

# Configure
Sensu::Apihelper.api_url("http://somehost:4567")

multiple_client_example = <<EOF
 [
   {
     "name": "client_1",
     "address": "192.168.0.2",
     "subscriptions": [
       "chef-client",
       "sensu-server"
     ],
     "timestamp": 1324674972
   },
   {
     "name": "client_2",
     "address": "192.168.0.3",
     "subscriptions": [
       "chef-client",
       "webserver",
       "memcached"
     ],
     "timestamp": 1324674956
   }
 ]
EOF

single_client_example = <<EOF
 {
   "name": "client_2",
   "address": "192.168.0.3",
   "subscriptions": [
     "chef-client",
     "webserver",
     "memcached"
   ],
   "timestamp": 1324674956
 }
EOF

check_execution_history = <<EOF
[
  {
    "check":"dummy_check",
    "history":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    "last_execution":0
  },
  {
    "check":"dummy_check_2",
    "history":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    "last_execution":0
  }
]
EOF


describe "Sensu-Apihelper" do

  it 'should fetch a list of clients' do

    # Stub list of clients
    stub_request(:get, "somehost:4567/clients").
    to_return(:status => 200, :body => multiple_client_example)

    # Stub check execution history
    stub_request(:get, /somehost:4567.*history$/).
    to_return(:status => 200, :body => check_execution_history)

    Sensu::Apihelper::Client.get_all.length.should be 2
  end

  it 'should fetch a client by name' do
    # Stub client
    stub_request(:get, "http://somehost:4567/clients/client_2").
    to_return(:status => 200, :body => single_client_example)

    # Stub check execution history
    stub_request(:get, /somehost:4567.*history$/).
    to_return(:status => 200, :body => check_execution_history)
    client = Sensu::Apihelper::Client.get_by_name("client_2")
    expect(client.name).to eq("client_2")
  end

end
