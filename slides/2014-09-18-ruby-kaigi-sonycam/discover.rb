require 'socket'
m_search = <<-EOS
M-SEARCH * HTTP/1.1\r
HOST: 239.255.255.250:1900\r
MAN: "ssdp:discover"\r
MX: 10\r
ST: urn:schemas-sony-com:service:ScalarWebAPI:1\r
\r
EOS

sock = UDPSocket.new
sock.bind('10.0.1.1', 0)
sock.send(m_search, 0, '239.255.255.250', 1900)
sock.recv(1024)