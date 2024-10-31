# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `async-http` gem.
# Please instead update this file by running `bin/tapioca gem async-http`.


# source://async-http//lib/async/http/body/writable.rb#9
module Async; end

# source://async-http//lib/async/http/body/writable.rb#10
module Async::HTTP; end

# source://async-http//lib/async/http/body/writable.rb#11
module Async::HTTP::Body; end

# Invokes a callback once the body has finished reading.
#
# source://async-http//lib/async/http/statistics.rb#32
class Async::HTTP::Body::Statistics < ::Protocol::HTTP::Body::Wrapper
  # @return [Statistics] a new instance of Statistics
  #
  # source://async-http//lib/async/http/statistics.rb#33
  def initialize(start_time, body, callback); end

  # source://async-http//lib/async/http/statistics.rb#63
  def close(error = T.unsafe(nil)); end

  # Returns the value of attribute end_time.
  #
  # source://async-http//lib/async/http/statistics.rb#47
  def end_time; end

  # source://async-http//lib/async/http/statistics.rb#57
  def first_chunk_duration; end

  # Returns the value of attribute first_chunk_time.
  #
  # source://async-http//lib/async/http/statistics.rb#46
  def first_chunk_time; end

  # source://async-http//lib/async/http/statistics.rb#95
  def inspect; end

  # source://async-http//lib/async/http/statistics.rb#69
  def read; end

  # Returns the value of attribute sent.
  #
  # source://async-http//lib/async/http/statistics.rb#49
  def sent; end

  # Returns the value of attribute start_time.
  #
  # source://async-http//lib/async/http/statistics.rb#45
  def start_time; end

  # source://async-http//lib/async/http/statistics.rb#81
  def to_s; end

  # source://async-http//lib/async/http/statistics.rb#51
  def total_duration; end

  private

  # source://async-http//lib/async/http/statistics.rb#101
  def complete_statistics(error = T.unsafe(nil)); end

  # source://async-http//lib/async/http/statistics.rb#107
  def format_duration(seconds); end
end

# source://async-http//lib/async/http/body/writable.rb#12
Async::HTTP::Body::Writable = Protocol::HTTP::Body::Writable

# A protocol specifies a way in which to communicate with a remote peer.
#
# source://async-http//lib/async/http/protocol/request.rb#13
module Async::HTTP::Protocol; end

# source://async-http//lib/async/http/protocol/http1/request.rb#11
module Async::HTTP::Protocol::HTTP1
  class << self
    # @return [Boolean]
    #
    # source://async-http//lib/async/http/protocol/http1.rb#18
    def bidirectional?; end

    # source://async-http//lib/async/http/protocol/http1.rb#26
    def client(peer); end

    # source://async-http//lib/async/http/protocol/http1.rb#38
    def names; end

    # source://async-http//lib/async/http/protocol/http1.rb#32
    def server(peer); end

    # @return [Boolean]
    #
    # source://async-http//lib/async/http/protocol/http1.rb#22
    def trailer?; end
  end
end

# source://async-http//lib/async/http/protocol/http10.rb#12
module Async::HTTP::Protocol::HTTP10
  class << self
    # @return [Boolean]
    #
    # source://async-http//lib/async/http/protocol/http10.rb#15
    def bidirectional?; end

    # source://async-http//lib/async/http/protocol/http10.rb#23
    def client(peer); end

    # source://async-http//lib/async/http/protocol/http10.rb#35
    def names; end

    # source://async-http//lib/async/http/protocol/http10.rb#29
    def server(peer); end

    # @return [Boolean]
    #
    # source://async-http//lib/async/http/protocol/http10.rb#19
    def trailer?; end
  end
end

# source://async-http//lib/async/http/protocol/http10.rb#13
Async::HTTP::Protocol::HTTP10::VERSION = T.let(T.unsafe(nil), String)

# source://async-http//lib/async/http/protocol/http11.rb#13
module Async::HTTP::Protocol::HTTP11
  class << self
    # @return [Boolean]
    #
    # source://async-http//lib/async/http/protocol/http11.rb#16
    def bidirectional?; end

    # source://async-http//lib/async/http/protocol/http11.rb#24
    def client(peer); end

    # source://async-http//lib/async/http/protocol/http11.rb#36
    def names; end

    # source://async-http//lib/async/http/protocol/http11.rb#30
    def server(peer); end

    # @return [Boolean]
    #
    # source://async-http//lib/async/http/protocol/http11.rb#20
    def trailer?; end
  end
end

# source://async-http//lib/async/http/protocol/http11.rb#14
Async::HTTP::Protocol::HTTP11::VERSION = T.let(T.unsafe(nil), String)

# source://async-http//lib/async/http/protocol/http1/client.rb#12
class Async::HTTP::Protocol::HTTP1::Client < ::Async::HTTP::Protocol::HTTP1::Connection
  # @return [Client] a new instance of Client
  #
  # source://async-http//lib/async/http/protocol/http1/client.rb#13
  def initialize(*_arg0, **_arg1, &_arg2); end

  # Used by the client to send requests to the remote server.
  #
  # source://async-http//lib/async/http/protocol/http1/client.rb#32
  def call(request, task: T.unsafe(nil)); end

  # source://async-http//lib/async/http/protocol/http1/client.rb#21
  def closed(error = T.unsafe(nil)); end

  # Returns the value of attribute pool.
  #
  # source://async-http//lib/async/http/protocol/http1/client.rb#19
  def pool; end

  # Sets the attribute pool
  #
  # @param value the value to set the attribute pool to.
  #
  # source://async-http//lib/async/http/protocol/http1/client.rb#19
  def pool=(_arg0); end
end

# source://async-http//lib/async/http/protocol/http1/connection.rb#15
class Async::HTTP::Protocol::HTTP1::Connection < ::Protocol::HTTP1::Connection
  # @return [Connection] a new instance of Connection
  #
  # source://async-http//lib/async/http/protocol/http1/connection.rb#16
  def initialize(stream, version); end

  # source://async-http//lib/async/http/protocol/http1/connection.rb#26
  def as_json(*_arg0, **_arg1, &_arg2); end

  # source://async-http//lib/async/http/protocol/http1/connection.rb#50
  def concurrency; end

  # Returns the value of attribute count.
  #
  # source://async-http//lib/async/http/protocol/http1/connection.rb#48
  def count; end

  # @return [Boolean]
  #
  # source://async-http//lib/async/http/protocol/http1/connection.rb#36
  def http1?; end

  # @return [Boolean]
  #
  # source://async-http//lib/async/http/protocol/http1/connection.rb#40
  def http2?; end

  # source://async-http//lib/async/http/protocol/http1/connection.rb#44
  def peer; end

  # @return [Boolean]
  #
  # source://async-http//lib/async/http/protocol/http1/connection.rb#59
  def reusable?; end

  # source://async-http//lib/async/http/protocol/http1/connection.rb#30
  def to_json(*_arg0, **_arg1, &_arg2); end

  # source://async-http//lib/async/http/protocol/http1/connection.rb#22
  def to_s; end

  # Returns the value of attribute version.
  #
  # source://async-http//lib/async/http/protocol/http1/connection.rb#34
  def version; end

  # Can we use this connection to make requests?
  #
  # @return [Boolean]
  #
  # source://async-http//lib/async/http/protocol/http1/connection.rb#55
  def viable?; end
end

# Keeps track of whether a body is being read, and if so, waits for it to be closed.
#
# source://async-http//lib/async/http/protocol/http1/finishable.rb#14
class Async::HTTP::Protocol::HTTP1::Finishable < ::Protocol::HTTP::Body::Wrapper
  # @return [Finishable] a new instance of Finishable
  #
  # source://async-http//lib/async/http/protocol/http1/finishable.rb#15
  def initialize(body); end

  # source://async-http//lib/async/http/protocol/http1/finishable.rb#34
  def close(error = T.unsafe(nil)); end

  # source://async-http//lib/async/http/protocol/http1/finishable.rb#55
  def inspect; end

  # source://async-http//lib/async/http/protocol/http1/finishable.rb#28
  def read; end

  # @return [Boolean]
  #
  # source://async-http//lib/async/http/protocol/http1/finishable.rb#24
  def reading?; end

  # source://async-http//lib/async/http/protocol/http1/finishable.rb#43
  def wait(persistent = T.unsafe(nil)); end
end

# source://async-http//lib/async/http/protocol/http1/request.rb#12
class Async::HTTP::Protocol::HTTP1::Request < ::Async::HTTP::Protocol::Request
  # @return [Request] a new instance of Request
  #
  # source://async-http//lib/async/http/protocol/http1/request.rb#21
  def initialize(connection, authority, method, path, version, headers, body); end

  # source://async-http//lib/async/http/protocol/http1/request.rb#30
  def connection; end

  # source://async-http//lib/async/http/protocol/http1/request.rb#38
  def hijack!; end

  # @return [Boolean]
  #
  # source://async-http//lib/async/http/protocol/http1/request.rb#34
  def hijack?; end

  # source://async-http//lib/async/http/protocol/http1/request.rb#42
  def write_interim_response(status, headers = T.unsafe(nil)); end

  class << self
    # source://async-http//lib/async/http/protocol/http1/request.rb#13
    def read(connection); end
  end
end

# source://async-http//lib/async/http/protocol/http1/request.rb#19
Async::HTTP::Protocol::HTTP1::Request::UPGRADE = T.let(T.unsafe(nil), String)

# source://async-http//lib/async/http/protocol/http1/response.rb#13
class Async::HTTP::Protocol::HTTP1::Response < ::Async::HTTP::Protocol::Response
  # @return [Response] a new instance of Response
  #
  # source://async-http//lib/async/http/protocol/http1/response.rb#32
  def initialize(connection, version, status, reason, headers, body); end

  # source://async-http//lib/async/http/protocol/http1/response.rb#50
  def connection; end

  # source://async-http//lib/async/http/protocol/http1/response.rb#58
  def hijack!; end

  # @return [Boolean]
  #
  # source://async-http//lib/async/http/protocol/http1/response.rb#54
  def hijack?; end

  # source://async-http//lib/async/http/protocol/http1/response.rb#42
  def pool=(pool); end

  # Returns the value of attribute reason.
  #
  # source://async-http//lib/async/http/protocol/http1/response.rb#29
  def reason; end

  class << self
    # source://async-http//lib/async/http/protocol/http1/response.rb#14
    def read(connection, request); end
  end
end

# source://async-http//lib/async/http/protocol/http1/response.rb#26
Async::HTTP::Protocol::HTTP1::Response::UPGRADE = T.let(T.unsafe(nil), String)

# source://async-http//lib/async/http/protocol/http1/server.rb#18
class Async::HTTP::Protocol::HTTP1::Server < ::Async::HTTP::Protocol::HTTP1::Connection
  # @return [Server] a new instance of Server
  #
  # source://async-http//lib/async/http/protocol/http1/server.rb#19
  def initialize(*_arg0, **_arg1, &_arg2); end

  # source://async-http//lib/async/http/protocol/http1/server.rb#25
  def closed(error = T.unsafe(nil)); end

  # Server loop.
  #
  # source://async-http//lib/async/http/protocol/http1/server.rb#62
  def each(task: T.unsafe(nil)); end

  # source://async-http//lib/async/http/protocol/http1/server.rb#31
  def fail_request(status); end

  # source://async-http//lib/async/http/protocol/http1/server.rb#40
  def next_request; end
end

# source://async-http//lib/async/http/protocol/http1.rb#16
Async::HTTP::Protocol::HTTP1::VERSION = T.let(T.unsafe(nil), String)

# source://async-http//lib/async/http/protocol/http2/input.rb#11
module Async::HTTP::Protocol::HTTP2
  class << self
    # @return [Boolean]
    #
    # source://async-http//lib/async/http/protocol/http2.rb#18
    def bidirectional?; end

    # source://async-http//lib/async/http/protocol/http2.rb#40
    def client(peer, settings = T.unsafe(nil)); end

    # source://async-http//lib/async/http/protocol/http2.rb#60
    def names; end

    # source://async-http//lib/async/http/protocol/http2.rb#50
    def server(peer, settings = T.unsafe(nil)); end

    # @return [Boolean]
    #
    # source://async-http//lib/async/http/protocol/http2.rb#22
    def trailer?; end
  end
end

# source://async-http//lib/async/http/protocol/http2/connection.rb#19
Async::HTTP::Protocol::HTTP2::AUTHORITY = T.let(T.unsafe(nil), String)

# source://async-http//lib/async/http/protocol/http2.rb#26
Async::HTTP::Protocol::HTTP2::CLIENT_SETTINGS = T.let(T.unsafe(nil), Hash)

# source://async-http//lib/async/http/protocol/http2/connection.rb#24
Async::HTTP::Protocol::HTTP2::CONNECTION = T.let(T.unsafe(nil), String)

# source://async-http//lib/async/http/protocol/http2/connection.rb#23
Async::HTTP::Protocol::HTTP2::CONTENT_LENGTH = T.let(T.unsafe(nil), String)

# source://async-http//lib/async/http/protocol/http2/client.rb#15
class Async::HTTP::Protocol::HTTP2::Client < ::Protocol::HTTP2::Client
  include ::Async::HTTP::Protocol::HTTP2::Connection

  # @return [Client] a new instance of Client
  #
  # source://async-http//lib/async/http/protocol/http2/client.rb#18
  def initialize(stream); end

  # Used by the client to send requests to the remote server.
  #
  # @raise [::Protocol::HTTP2::Error]
  #
  # source://async-http//lib/async/http/protocol/http2/client.rb#31
  def call(request); end

  # source://async-http//lib/async/http/protocol/http2/client.rb#26
  def create_response; end
end

# source://async-http//lib/async/http/protocol/http2/connection.rb#27
module Async::HTTP::Protocol::HTTP2::Connection
  # source://async-http//lib/async/http/protocol/http2/connection.rb#28
  def initialize(*_arg0); end

  # source://async-http//lib/async/http/protocol/http2/connection.rb#46
  def as_json(*_arg0, **_arg1, &_arg2); end

  # source://async-http//lib/async/http/protocol/http2/connection.rb#68
  def close(error = T.unsafe(nil)); end

  # source://async-http//lib/async/http/protocol/http2/connection.rb#120
  def concurrency; end

  # Returns the value of attribute count.
  #
  # source://async-http//lib/async/http/protocol/http2/connection.rb#118
  def count; end

  # @return [Boolean]
  #
  # source://async-http//lib/async/http/protocol/http2/connection.rb#56
  def http1?; end

  # @return [Boolean]
  #
  # source://async-http//lib/async/http/protocol/http2/connection.rb#60
  def http2?; end

  # source://async-http//lib/async/http/protocol/http2/connection.rb#114
  def peer; end

  # Returns the value of attribute promises.
  #
  # source://async-http//lib/async/http/protocol/http2/connection.rb#112
  def promises; end

  # @raise [RuntimeError]
  #
  # source://async-http//lib/async/http/protocol/http2/connection.rb#79
  def read_in_background(parent: T.unsafe(nil)); end

  # @return [Boolean]
  #
  # source://async-http//lib/async/http/protocol/http2/connection.rb#129
  def reusable?; end

  # source://async-http//lib/async/http/protocol/http2/connection.rb#64
  def start_connection; end

  # Returns the value of attribute stream.
  #
  # source://async-http//lib/async/http/protocol/http2/connection.rb#54
  def stream; end

  # source://async-http//lib/async/http/protocol/http2/connection.rb#38
  def synchronize(&block); end

  # source://async-http//lib/async/http/protocol/http2/connection.rb#50
  def to_json(*_arg0, **_arg1, &_arg2); end

  # source://async-http//lib/async/http/protocol/http2/connection.rb#42
  def to_s; end

  # source://async-http//lib/async/http/protocol/http2/connection.rb#133
  def version; end

  # Can we use this connection to make requests?
  #
  # @return [Boolean]
  #
  # source://async-http//lib/async/http/protocol/http2/connection.rb#125
  def viable?; end
end

# source://async-http//lib/async/http/protocol/http2/connection.rb#15
Async::HTTP::Protocol::HTTP2::HTTPS = T.let(T.unsafe(nil), String)

# A writable body which requests window updates when data is read from it.
#
# source://async-http//lib/async/http/protocol/http2/input.rb#13
class Async::HTTP::Protocol::HTTP2::Input < ::Protocol::HTTP::Body::Writable
  # @return [Input] a new instance of Input
  #
  # source://async-http//lib/async/http/protocol/http2/input.rb#14
  def initialize(stream, length); end

  # source://async-http//lib/async/http/protocol/http2/input.rb#21
  def read; end
end

# source://async-http//lib/async/http/protocol/http2/connection.rb#17
Async::HTTP::Protocol::HTTP2::METHOD = T.let(T.unsafe(nil), String)

# source://async-http//lib/async/http/protocol/http2/output.rb#12
class Async::HTTP::Protocol::HTTP2::Output
  # @return [Output] a new instance of Output
  #
  # source://async-http//lib/async/http/protocol/http2/output.rb#13
  def initialize(stream, body, trailer = T.unsafe(nil)); end

  # This method should only be called from within the context of the output task.
  #
  # source://async-http//lib/async/http/protocol/http2/output.rb#71
  def close(error = T.unsafe(nil)); end

  # source://async-http//lib/async/http/protocol/http2/output.rb#63
  def close_write(error = T.unsafe(nil)); end

  # source://async-http//lib/async/http/protocol/http2/output.rb#26
  def start(parent: T.unsafe(nil)); end

  # This method should only be called from within the context of the HTTP/2 stream.
  #
  # source://async-http//lib/async/http/protocol/http2/output.rb#77
  def stop(error); end

  # Returns the value of attribute trailer.
  #
  # source://async-http//lib/async/http/protocol/http2/output.rb#24
  def trailer; end

  # source://async-http//lib/async/http/protocol/http2/output.rb#36
  def window_updated(size); end

  # source://async-http//lib/async/http/protocol/http2/output.rb#42
  def write(chunk); end

  private

  # Reads chunks from the given body and writes them to the stream as fast as possible.
  #
  # source://async-http//lib/async/http/protocol/http2/output.rb#99
  def passthrough(task); end

  # Send `maximum_size` bytes of data using the specified `stream`. If the buffer has no more chunks, `END_STREAM` will be sent on the final chunk.
  #
  # @param maximum_size [Integer] send up to this many bytes of data.
  # @param stream [Stream] the stream to use for sending data frames.
  # @return [String, nil] any data that could not be written.
  #
  # source://async-http//lib/async/http/protocol/http2/output.rb#125
  def send_data(chunk, maximum_size); end

  # source://async-http//lib/async/http/protocol/http2/output.rb#86
  def stream(task); end
end

# source://async-http//lib/async/http/protocol/http2/connection.rb#18
Async::HTTP::Protocol::HTTP2::PATH = T.let(T.unsafe(nil), String)

# source://async-http//lib/async/http/protocol/http2/connection.rb#21
Async::HTTP::Protocol::HTTP2::PROTOCOL = T.let(T.unsafe(nil), String)

# Typically used on the server side to represent an incoming request, and write the response.
#
# source://async-http//lib/async/http/protocol/http2/request.rb#14
class Async::HTTP::Protocol::HTTP2::Request < ::Async::HTTP::Protocol::Request
  # @return [Request] a new instance of Request
  #
  # source://async-http//lib/async/http/protocol/http2/request.rb#89
  def initialize(stream); end

  # source://async-http//lib/async/http/protocol/http2/request.rb#97
  def connection; end

  # @return [Boolean]
  #
  # source://async-http//lib/async/http/protocol/http2/request.rb#105
  def hijack?; end

  # source://async-http//lib/async/http/protocol/http2/request.rb#113
  def send_response(response); end

  # Returns the value of attribute stream.
  #
  # source://async-http//lib/async/http/protocol/http2/request.rb#95
  def stream; end

  # @return [Boolean]
  #
  # source://async-http//lib/async/http/protocol/http2/request.rb#101
  def valid?; end

  # source://async-http//lib/async/http/protocol/http2/request.rb#143
  def write_interim_response(status, headers = T.unsafe(nil)); end
end

# source://async-http//lib/async/http/protocol/http2/request.rb#109
Async::HTTP::Protocol::HTTP2::Request::NO_RESPONSE = T.let(T.unsafe(nil), Array)

# source://async-http//lib/async/http/protocol/http2/request.rb#15
class Async::HTTP::Protocol::HTTP2::Request::Stream < ::Async::HTTP::Protocol::HTTP2::Stream
  # @return [Stream] a new instance of Stream
  #
  # source://async-http//lib/async/http/protocol/http2/request.rb#16
  def initialize(*_arg0); end

  # source://async-http//lib/async/http/protocol/http2/request.rb#82
  def closed(error); end

  # source://async-http//lib/async/http/protocol/http2/request.rb#25
  def receive_initial_headers(headers, end_stream); end

  # Returns the value of attribute request.
  #
  # source://async-http//lib/async/http/protocol/http2/request.rb#23
  def request; end
end

# Typically used on the client side for writing a request and reading the incoming response.
#
# source://async-http//lib/async/http/protocol/http2/response.rb#14
class Async::HTTP::Protocol::HTTP2::Response < ::Async::HTTP::Protocol::Response
  # @return [Response] a new instance of Response
  #
  # source://async-http//lib/async/http/protocol/http2/response.rb#130
  def initialize(stream); end

  # source://async-http//lib/async/http/protocol/http2/response.rb#166
  def build_request(headers); end

  # source://async-http//lib/async/http/protocol/http2/response.rb#150
  def connection; end

  # @return [Boolean]
  #
  # source://async-http//lib/async/http/protocol/http2/response.rb#158
  def head?; end

  # source://async-http//lib/async/http/protocol/http2/response.rb#140
  def pool=(pool); end

  # Returns the value of attribute request.
  #
  # source://async-http//lib/async/http/protocol/http2/response.rb#138
  def request; end

  # Send a request and read it into this response.
  #
  # source://async-http//lib/async/http/protocol/http2/response.rb#199
  def send_request(request); end

  # Returns the value of attribute stream.
  #
  # source://async-http//lib/async/http/protocol/http2/response.rb#137
  def stream; end

  # @return [Boolean]
  #
  # source://async-http//lib/async/http/protocol/http2/response.rb#162
  def valid?; end

  # source://async-http//lib/async/http/protocol/http2/response.rb#154
  def wait; end
end

# source://async-http//lib/async/http/protocol/http2/response.rb#15
class Async::HTTP::Protocol::HTTP2::Response::Stream < ::Async::HTTP::Protocol::HTTP2::Stream
  # @return [Stream] a new instance of Stream
  #
  # source://async-http//lib/async/http/protocol/http2/response.rb#16
  def initialize(*_arg0); end

  # @raise [ProtocolError]
  #
  # source://async-http//lib/async/http/protocol/http2/response.rb#35
  def accept_push_promise_stream(promised_stream_id, headers); end

  # source://async-http//lib/async/http/protocol/http2/response.rb#117
  def closed(error); end

  # Notify anyone waiting on the response headers to be received (or failure).
  #
  # source://async-http//lib/async/http/protocol/http2/response.rb#100
  def notify!; end

  # This should be invoked from the background reader, and notifies the task waiting for the headers that we are done.
  #
  # source://async-http//lib/async/http/protocol/http2/response.rb#40
  def receive_initial_headers(headers, end_stream); end

  # source://async-http//lib/async/http/protocol/http2/response.rb#89
  def receive_interim_headers(status, headers); end

  # Returns the value of attribute response.
  #
  # source://async-http//lib/async/http/protocol/http2/response.rb#25
  def response; end

  # Wait for the headers to be received or for stream reset.
  #
  # source://async-http//lib/async/http/protocol/http2/response.rb#108
  def wait; end

  # source://async-http//lib/async/http/protocol/http2/response.rb#27
  def wait_for_input; end
end

# source://async-http//lib/async/http/protocol/http2/connection.rb#16
Async::HTTP::Protocol::HTTP2::SCHEME = T.let(T.unsafe(nil), String)

# source://async-http//lib/async/http/protocol/http2.rb#32
Async::HTTP::Protocol::HTTP2::SERVER_SETTINGS = T.let(T.unsafe(nil), Hash)

# source://async-http//lib/async/http/protocol/http2/connection.rb#20
Async::HTTP::Protocol::HTTP2::STATUS = T.let(T.unsafe(nil), String)

# source://async-http//lib/async/http/protocol/http2/server.rb#15
class Async::HTTP::Protocol::HTTP2::Server < ::Protocol::HTTP2::Server
  include ::Async::HTTP::Protocol::HTTP2::Connection

  # @return [Server] a new instance of Server
  #
  # source://async-http//lib/async/http/protocol/http2/server.rb#18
  def initialize(stream); end

  # source://async-http//lib/async/http/protocol/http2/server.rb#31
  def accept_stream(stream_id); end

  # source://async-http//lib/async/http/protocol/http2/server.rb#37
  def close(error = T.unsafe(nil)); end

  # source://async-http//lib/async/http/protocol/http2/server.rb#47
  def each(task: T.unsafe(nil)); end

  # Returns the value of attribute requests.
  #
  # source://async-http//lib/async/http/protocol/http2/server.rb#29
  def requests; end
end

# source://async-http//lib/async/http/protocol/http2/stream.rb#17
class Async::HTTP::Protocol::HTTP2::Stream < ::Protocol::HTTP2::Stream
  # @return [Stream] a new instance of Stream
  #
  # source://async-http//lib/async/http/protocol/http2/stream.rb#18
  def initialize(*_arg0); end

  # source://async-http//lib/async/http/protocol/http2/stream.rb#39
  def add_header(key, value); end

  # When the stream transitions to the closed state, this method is called. There are roughly two ways this can happen:
  # - A frame is received which causes this stream to enter the closed state. This method will be invoked from the background reader task.
  # - A frame is sent which causes this stream to enter the closed state. This method will be invoked from that task.
  # While the input stream is relatively straight forward, the output stream can trigger the second case above
  #
  # source://async-http//lib/async/http/protocol/http2/stream.rb#151
  def closed(error); end

  # Called when the output terminates normally.
  #
  # source://async-http//lib/async/http/protocol/http2/stream.rb#122
  def finish_output(error = T.unsafe(nil)); end

  # Returns the value of attribute headers.
  #
  # source://async-http//lib/async/http/protocol/http2/stream.rb#33
  def headers; end

  # Sets the attribute headers
  #
  # @param value the value to set the attribute headers to.
  #
  # source://async-http//lib/async/http/protocol/http2/stream.rb#33
  def headers=(_arg0); end

  # Returns the value of attribute input.
  #
  # source://async-http//lib/async/http/protocol/http2/stream.rb#37
  def input; end

  # Returns the value of attribute pool.
  #
  # source://async-http//lib/async/http/protocol/http2/stream.rb#35
  def pool; end

  # Sets the attribute pool
  #
  # @param value the value to set the attribute pool to.
  #
  # source://async-http//lib/async/http/protocol/http2/stream.rb#35
  def pool=(_arg0); end

  # Prepare the input stream which will be used for incoming data frames.
  #
  # @return [Input] the input body.
  #
  # source://async-http//lib/async/http/protocol/http2/stream.rb#79
  def prepare_input(length); end

  # source://async-http//lib/async/http/protocol/http2/stream.rb#94
  def process_data(frame); end

  # source://async-http//lib/async/http/protocol/http2/stream.rb#57
  def process_headers(frame); end

  # source://async-http//lib/async/http/protocol/http2/stream.rb#51
  def receive_trailing_headers(headers, end_stream); end

  # Set the body and begin sending it.
  #
  # source://async-http//lib/async/http/protocol/http2/stream.rb#115
  def send_body(body, trailer = T.unsafe(nil)); end

  # source://async-http//lib/async/http/protocol/http2/stream.rb#87
  def update_local_window(frame); end

  # source://async-http//lib/async/http/protocol/http2/stream.rb#73
  def wait_for_input; end

  # source://async-http//lib/async/http/protocol/http2/stream.rb#141
  def window_updated(size); end
end

# source://async-http//lib/async/http/protocol/http2/connection.rb#25
Async::HTTP::Protocol::HTTP2::TRAILER = T.let(T.unsafe(nil), String)

# source://async-http//lib/async/http/protocol/http2.rb#16
Async::HTTP::Protocol::HTTP2::VERSION = T.let(T.unsafe(nil), String)

# A server that supports both HTTP1.0 and HTTP1.1 semantics by detecting the version of the request.
#
# source://async-http//lib/async/http/protocol/https.rb#16
module Async::HTTP::Protocol::HTTPS
  class << self
    # source://async-http//lib/async/http/protocol/https.rb#37
    def client(peer); end

    # Supported Application Layer Protocol Negotiation names:
    #
    # source://async-http//lib/async/http/protocol/https.rb#46
    def names; end

    # source://async-http//lib/async/http/protocol/https.rb#24
    def protocol_for(peer); end

    # source://async-http//lib/async/http/protocol/https.rb#41
    def server(peer); end
  end
end

# source://async-http//lib/async/http/protocol/https.rb#17
Async::HTTP::Protocol::HTTPS::HANDLERS = T.let(T.unsafe(nil), Hash)

# This is generated by server protocols.
#
# source://async-http//lib/async/http/protocol/request.rb#19
class Async::HTTP::Protocol::Request < ::Protocol::HTTP::Request
  # source://async-http//lib/async/http/protocol/request.rb#20
  def connection; end

  # @return [Boolean]
  #
  # source://async-http//lib/async/http/protocol/request.rb#24
  def hijack?; end

  # source://async-http//lib/async/http/protocol/request.rb#45
  def inspect; end

  # source://async-http//lib/async/http/protocol/request.rb#31
  def peer; end

  # source://async-http//lib/async/http/protocol/request.rb#37
  def remote_address; end

  # source://async-http//lib/async/http/protocol/request.rb#41
  def remote_address=(value); end

  # source://async-http//lib/async/http/protocol/request.rb#28
  def write_interim_response(status, headers = T.unsafe(nil)); end
end

# Failed to send the request. The request body has NOT been consumed (i.e. #read) and you should retry the request.
#
# source://async-http//lib/async/http/protocol/request.rb#15
class Async::HTTP::Protocol::RequestFailed < ::StandardError; end

# This is generated by client protocols.
#
# source://async-http//lib/async/http/protocol/response.rb#14
class Async::HTTP::Protocol::Response < ::Protocol::HTTP::Response
  # source://async-http//lib/async/http/protocol/response.rb#15
  def connection; end

  # @return [Boolean]
  #
  # source://async-http//lib/async/http/protocol/response.rb#19
  def hijack?; end

  # source://async-http//lib/async/http/protocol/response.rb#37
  def inspect; end

  # source://async-http//lib/async/http/protocol/response.rb#23
  def peer; end

  # source://async-http//lib/async/http/protocol/response.rb#29
  def remote_address; end

  # source://async-http//lib/async/http/protocol/response.rb#33
  def remote_address=(value); end
end

# source://async-http//lib/async/http/server.rb#16
class Async::HTTP::Server < ::Protocol::HTTP::Middleware
  # @return [Server] a new instance of Server
  #
  # source://async-http//lib/async/http/server.rb#21
  def initialize(app, endpoint, protocol: T.unsafe(nil), scheme: T.unsafe(nil)); end

  # source://async-http//lib/async/http/server.rb#45
  def accept(peer, address, task: T.unsafe(nil)); end

  # source://async-http//lib/async/http/server.rb#29
  def as_json(*_arg0, **_arg1, &_arg2); end

  # Returns the value of attribute endpoint.
  #
  # source://async-http//lib/async/http/server.rb#41
  def endpoint; end

  # Returns the value of attribute protocol.
  #
  # source://async-http//lib/async/http/server.rb#42
  def protocol; end

  # source://async-http//lib/async/http/server.rb#68
  def run; end

  # Returns the value of attribute scheme.
  #
  # source://async-http//lib/async/http/server.rb#43
  def scheme; end

  # source://async-http//lib/async/http/server.rb#37
  def to_json(*_arg0, **_arg1, &_arg2); end

  class << self
    # source://async-http//lib/async/http/server.rb#17
    def for(*arguments, **options, &block); end
  end
end

# source://async-http//lib/async/http/statistics.rb#12
class Async::HTTP::Statistics
  # @return [Statistics] a new instance of Statistics
  #
  # source://async-http//lib/async/http/statistics.rb#17
  def initialize(start_time); end

  # source://async-http//lib/async/http/statistics.rb#21
  def wrap(response, &block); end

  class << self
    # source://async-http//lib/async/http/statistics.rb#13
    def start; end
  end
end