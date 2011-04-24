require 'test/unit'
require 'socket'

class RedisTest < Test::Unit::TestCase
  def test_can_get_what_is_put
    # test if redis is there
    client = RedisClient.new
    client.connect
    client.send_cmd("SET yabi abri")
    #client.send_cmd("quit")
    client.close
  end
  
  class RedisClient
    
    def initialize
      @sock = nil
    end

    def connect(host='localhost', port=6379)

      @sock = TCPSocket.new(host, port) 
      #@sock = TCPSocket.open(host, port) 

      #@sock = TCPSocket.open('localhost', 6379) 
      #@sock.setsockopt Socket::IPPROTO_TCP, Socket::TCP_NODELAY, 1
  
    end

    def build_msg(str)
      toks = str.split(" ")

      msg = toks.collect {|a| "$#{a.size}\r\n#{a}\r\n"}
      #puts "msg = #{msg}"

      cmd = "*#{toks.size}\r\n#{msg}"
      puts "cmd = #{cmd}"
      cmd = "*#{toks.size}\r\n#{msg}"

      return cmd
    
    end

    def send_cmd(msg)
      connect unless @sock.class == 'TCPSocket'  
      @sock.write(build_msg(msg))
      puts "message sent"
      type = @sock.read(1)
      puts "type = #{type}"
      reply_string = @sock.gets 
      puts "reply_string = #{reply_string}"
      
      #reply_factory(type, reply_string) 

    end
    def close
      @sock.close
    end
  end
end 
