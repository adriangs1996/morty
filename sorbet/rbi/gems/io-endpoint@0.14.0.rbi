# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `io-endpoint` gem.
# Please instead update this file by running `bin/tapioca gem io-endpoint`.


# source://io-endpoint//lib/io/endpoint/version.rb#6
class IO
  include ::Enumerable
  include ::File::Constants
end

class IO::Buffer
  include ::Comparable

  def initialize(*_arg0); end

  def &(_arg0); end
  def <=>(_arg0); end
  def ^(_arg0); end
  def and!(_arg0); end
  def clear(*_arg0); end
  def copy(*_arg0); end
  def each(*_arg0); end
  def each_byte(*_arg0); end
  def empty?; end
  def external?; end
  def free; end
  def get_string(*_arg0); end
  def get_value(_arg0, _arg1); end
  def get_values(_arg0, _arg1); end
  def hexdump; end
  def inspect; end
  def internal?; end
  def locked; end
  def locked?; end
  def mapped?; end
  def not!; end
  def null?; end
  def or!(_arg0); end
  def pread(*_arg0); end
  def pwrite(*_arg0); end
  def read(*_arg0); end
  def readonly?; end
  def resize(_arg0); end
  def set_string(*_arg0); end
  def set_value(_arg0, _arg1, _arg2); end
  def set_values(_arg0, _arg1, _arg2); end
  def shared?; end
  def size; end
  def slice(*_arg0); end
  def to_s; end
  def transfer; end
  def valid?; end
  def values(*_arg0); end
  def write(*_arg0); end
  def xor!(_arg0); end
  def |(_arg0); end
  def ~; end

  private

  def initialize_copy(_arg0); end

  class << self
    def for(_arg0); end
    def map(*_arg0); end
    def size_of(_arg0); end
  end
end

class IO::Buffer::AccessError < ::RuntimeError; end
class IO::Buffer::AllocationError < ::RuntimeError; end
IO::Buffer::BIG_ENDIAN = T.let(T.unsafe(nil), Integer)
IO::Buffer::DEFAULT_SIZE = T.let(T.unsafe(nil), Integer)
IO::Buffer::EXTERNAL = T.let(T.unsafe(nil), Integer)
IO::Buffer::HOST_ENDIAN = T.let(T.unsafe(nil), Integer)
IO::Buffer::INTERNAL = T.let(T.unsafe(nil), Integer)
class IO::Buffer::InvalidatedError < ::RuntimeError; end
IO::Buffer::LITTLE_ENDIAN = T.let(T.unsafe(nil), Integer)
IO::Buffer::LOCKED = T.let(T.unsafe(nil), Integer)
class IO::Buffer::LockedError < ::RuntimeError; end
IO::Buffer::MAPPED = T.let(T.unsafe(nil), Integer)
class IO::Buffer::MaskError < ::ArgumentError; end
IO::Buffer::NETWORK_ENDIAN = T.let(T.unsafe(nil), Integer)
IO::Buffer::PAGE_SIZE = T.let(T.unsafe(nil), Integer)
IO::Buffer::PRIVATE = T.let(T.unsafe(nil), Integer)
IO::Buffer::READONLY = T.let(T.unsafe(nil), Integer)
IO::Buffer::SHARED = T.let(T.unsafe(nil), Integer)

class IO::ConsoleMode
  def echo=(_arg0); end
  def raw(*_arg0); end
  def raw!(*_arg0); end

  private

  def initialize_copy(_arg0); end
end

class IO::EAGAINWaitReadable < ::Errno::EAGAIN
  include ::IO::WaitReadable
end

class IO::EAGAINWaitWritable < ::Errno::EAGAIN
  include ::IO::WaitWritable
end

class IO::EINPROGRESSWaitReadable < ::Errno::EINPROGRESS
  include ::IO::WaitReadable
end

class IO::EINPROGRESSWaitWritable < ::Errno::EINPROGRESS
  include ::IO::WaitWritable
end

IO::EWOULDBLOCKWaitReadable = IO::EAGAINWaitReadable
IO::EWOULDBLOCKWaitWritable = IO::EAGAINWaitWritable

# source://io-endpoint//lib/io/endpoint/version.rb#7
module IO::Endpoint
  class << self
    # source://io-endpoint//lib/io/endpoint/composite_endpoint.rb#71
    def composite(*endpoints, **options); end

    # source://io-endpoint//lib/io/endpoint.rb#11
    def file_descriptor_limit; end

    # source://io-endpoint//lib/io/endpoint/socket_endpoint.rb#44
    def socket(socket, **options); end
  end
end

# source://io-endpoint//lib/io/endpoint/generic.rb#11
IO::Endpoint::Address = Addrinfo

# source://io-endpoint//lib/io/endpoint/address_endpoint.rb#12
class IO::Endpoint::AddressEndpoint < ::IO::Endpoint::Generic
  # @return [AddressEndpoint] a new instance of AddressEndpoint
  #
  # source://io-endpoint//lib/io/endpoint/address_endpoint.rb#13
  def initialize(address, **options); end

  # Returns the value of attribute address.
  #
  # source://io-endpoint//lib/io/endpoint/address_endpoint.rb#34
  def address; end

  # Bind a socket to the given address. If a block is given, the socket will be automatically closed when the block exits.
  #
  # @return [Array(Socket)] the bound socket
  # @yield [|socket| ...] An optional block which will be passed the socket.
  #   @parameter socket [Socket] The socket which has been bound.
  #
  # source://io-endpoint//lib/io/endpoint/address_endpoint.rb#40
  def bind(wrapper = T.unsafe(nil), &block); end

  # Connects a socket to the given address. If a block is given, the socket will be automatically closed when the block exits.
  #
  # @return [Socket] the connected socket
  #
  # source://io-endpoint//lib/io/endpoint/address_endpoint.rb#46
  def connect(wrapper = T.unsafe(nil), &block); end

  # source://io-endpoint//lib/io/endpoint/address_endpoint.rb#30
  def inspect; end

  # source://io-endpoint//lib/io/endpoint/address_endpoint.rb#19
  def to_s; end
end

# source://io-endpoint//lib/io/endpoint/bound_endpoint.rb#11
class IO::Endpoint::BoundEndpoint < ::IO::Endpoint::Generic
  # @return [BoundEndpoint] a new instance of BoundEndpoint
  #
  # source://io-endpoint//lib/io/endpoint/bound_endpoint.rb#22
  def initialize(endpoint, sockets, **options); end

  # source://io-endpoint//lib/io/endpoint/bound_endpoint.rb#65
  def bind(wrapper = T.unsafe(nil), &block); end

  # source://io-endpoint//lib/io/endpoint/bound_endpoint.rb#52
  def close; end

  # Returns the value of attribute endpoint.
  #
  # source://io-endpoint//lib/io/endpoint/bound_endpoint.rb#29
  def endpoint; end

  # source://io-endpoint//lib/io/endpoint/bound_endpoint.rb#61
  def inspect; end

  # A endpoint for the local end of the bound socket.
  #
  # source://io-endpoint//lib/io/endpoint/bound_endpoint.rb#34
  def local_address_endpoint(**options); end

  # A endpoint for the remote end of the bound socket.
  #
  # source://io-endpoint//lib/io/endpoint/bound_endpoint.rb#44
  def remote_address_endpoint(**options); end

  # Returns the value of attribute sockets.
  #
  # source://io-endpoint//lib/io/endpoint/bound_endpoint.rb#30
  def sockets; end

  # source://io-endpoint//lib/io/endpoint/bound_endpoint.rb#57
  def to_s; end

  class << self
    # source://io-endpoint//lib/io/endpoint/bound_endpoint.rb#12
    def bound(endpoint, backlog: T.unsafe(nil), close_on_exec: T.unsafe(nil)); end
  end
end

# A composite endpoint is a collection of endpoints that are used in order.
#
# source://io-endpoint//lib/io/endpoint/composite_endpoint.rb#10
class IO::Endpoint::CompositeEndpoint < ::IO::Endpoint::Generic
  # @return [CompositeEndpoint] a new instance of CompositeEndpoint
  #
  # source://io-endpoint//lib/io/endpoint/composite_endpoint.rb#11
  def initialize(endpoints, **options); end

  # source://io-endpoint//lib/io/endpoint/composite_endpoint.rb#60
  def bind(wrapper = T.unsafe(nil), &block); end

  # source://io-endpoint//lib/io/endpoint/composite_endpoint.rb#47
  def connect(wrapper = T.unsafe(nil), &block); end

  # source://io-endpoint//lib/io/endpoint/composite_endpoint.rb#41
  def each(&block); end

  # Returns the value of attribute endpoints.
  #
  # source://io-endpoint//lib/io/endpoint/composite_endpoint.rb#34
  def endpoints; end

  # source://io-endpoint//lib/io/endpoint/composite_endpoint.rb#26
  def inspect; end

  # The number of endpoints in the composite endpoint.
  #
  # source://io-endpoint//lib/io/endpoint/composite_endpoint.rb#37
  def size; end

  # source://io-endpoint//lib/io/endpoint/composite_endpoint.rb#22
  def to_s; end

  # source://io-endpoint//lib/io/endpoint/composite_endpoint.rb#30
  def with(**options); end
end

# source://io-endpoint//lib/io/endpoint/connected_endpoint.rb#13
class IO::Endpoint::ConnectedEndpoint < ::IO::Endpoint::Generic
  # @return [ConnectedEndpoint] a new instance of ConnectedEndpoint
  #
  # source://io-endpoint//lib/io/endpoint/connected_endpoint.rb#22
  def initialize(endpoint, socket, **options); end

  # source://io-endpoint//lib/io/endpoint/connected_endpoint.rb#52
  def close; end

  # source://io-endpoint//lib/io/endpoint/connected_endpoint.rb#44
  def connect(wrapper = T.unsafe(nil), &block); end

  # Returns the value of attribute endpoint.
  #
  # source://io-endpoint//lib/io/endpoint/connected_endpoint.rb#29
  def endpoint; end

  # source://io-endpoint//lib/io/endpoint/connected_endpoint.rb#63
  def inspect; end

  # A endpoint for the local end of the bound socket.
  #
  # source://io-endpoint//lib/io/endpoint/connected_endpoint.rb#34
  def local_address_endpoint(**options); end

  # A endpoint for the remote end of the bound socket.
  #
  # source://io-endpoint//lib/io/endpoint/connected_endpoint.rb#40
  def remote_address_endpoint(**options); end

  # Returns the value of attribute socket.
  #
  # source://io-endpoint//lib/io/endpoint/connected_endpoint.rb#30
  def socket; end

  # source://io-endpoint//lib/io/endpoint/connected_endpoint.rb#59
  def to_s; end

  class << self
    # source://io-endpoint//lib/io/endpoint/connected_endpoint.rb#14
    def connected(endpoint, close_on_exec: T.unsafe(nil)); end
  end
end

# source://io-endpoint//lib/io/endpoint/wrapper.rb#194
class IO::Endpoint::FiberWrapper < ::IO::Endpoint::Wrapper
  # source://io-endpoint//lib/io/endpoint/wrapper.rb#195
  def async(&block); end
end

# Endpoints represent a way of connecting or binding to an address.
#
# source://io-endpoint//lib/io/endpoint/generic.rb#14
class IO::Endpoint::Generic
  # @return [Generic] a new instance of Generic
  #
  # source://io-endpoint//lib/io/endpoint/generic.rb#15
  def initialize(**options); end

  # Bind and accept connections on the given address.
  #
  # source://io-endpoint//lib/io/endpoint/generic.rb#81
  def accept(wrapper = T.unsafe(nil), &block); end

  # Bind a socket to the given address. If a block is given, the socket will be automatically closed when the block exits.
  #
  # @raise [NotImplementedError]
  #
  # source://io-endpoint//lib/io/endpoint/generic.rb#67
  def bind(wrapper = T.unsafe(nil), &block); end

  # source://io-endpoint//lib/io/endpoint/bound_endpoint.rb#79
  def bound(**options); end

  # Connects a socket to the given address. If a block is given, the socket will be automatically closed when the block exits.
  #
  # @raise [NotImplementedError]
  # @return [Socket] the connected socket
  #
  # source://io-endpoint//lib/io/endpoint/generic.rb#74
  def connect(wrapper = T.unsafe(nil), &block); end

  # source://io-endpoint//lib/io/endpoint/connected_endpoint.rb#69
  def connected(**options); end

  # Enumerate all discrete paths as endpoints.
  #
  # @yield [_self]
  # @yieldparam _self [IO::Endpoint::Generic] the object that the method was called on
  #
  # source://io-endpoint//lib/io/endpoint/generic.rb#90
  def each; end

  # @return [String] The hostname of the bound socket.
  #
  # source://io-endpoint//lib/io/endpoint/generic.rb#30
  def hostname; end

  # Controls SO_LINGER. The amount of time the socket will stay in the `TIME_WAIT` state after being closed.
  #
  # @return [Integer, nil] The value for SO_LINGER.
  #
  # source://io-endpoint//lib/io/endpoint/generic.rb#48
  def linger; end

  # @return [Address] the address to bind to before connecting.
  #
  # source://io-endpoint//lib/io/endpoint/generic.rb#58
  def local_address; end

  # Returns the value of attribute options.
  #
  # source://io-endpoint//lib/io/endpoint/generic.rb#27
  def options; end

  # Sets the attribute options
  #
  # @param value the value to set the attribute options to.
  #
  # source://io-endpoint//lib/io/endpoint/generic.rb#27
  def options=(_arg0); end

  # If `SO_REUSEADDR` is enabled on a socket prior to binding it, the socket can be successfully bound unless there is a conflict with another socket bound to exactly the same combination of source address and port. Additionally, when set, binding a socket to the address of an existing socket in `TIME_WAIT` is not an error.
  #
  # @return [Boolean] The value for `SO_REUSEADDR`.
  #
  # source://io-endpoint//lib/io/endpoint/generic.rb#42
  def reuse_address?; end

  # If `SO_REUSEPORT` is enabled on a socket, the socket can be successfully bound even if there are existing sockets bound to the same address, as long as all prior bound sockets also had `SO_REUSEPORT` set before they were bound.
  #
  # @return [Boolean, nil] The value for `SO_REUSEPORT`.
  #
  # source://io-endpoint//lib/io/endpoint/generic.rb#36
  def reuse_port?; end

  # @return [Numeric] The default timeout for socket operations.
  #
  # source://io-endpoint//lib/io/endpoint/generic.rb#53
  def timeout; end

  # source://io-endpoint//lib/io/endpoint/generic.rb#19
  def with(**options); end

  class << self
    # Create an Endpoint instance by URI scheme. The host and port of the URI will be passed to the Endpoint factory method, along with any options.
    #
    # You should not use untrusted input as it may execute arbitrary code.
    #
    # @param string [String] URI as string. Scheme will decide implementation used.
    # @param options keyword arguments passed through to {#initialize}
    # @see Endpoint.ssl ssl - invoked when parsing a URL with the ssl scheme "ssl://127.0.0.1"
    # @see Endpoint.tcp tcp - invoked when parsing a URL with the tcp scheme: "tcp://127.0.0.1"
    # @see Endpoint.udp udp - invoked when parsing a URL with the udp scheme: "udp://127.0.0.1"
    # @see Endpoint.unix unix - invoked when parsing a URL with the unix scheme: "unix://127.0.0.1"
    #
    # source://io-endpoint//lib/io/endpoint/generic.rb#107
    def parse(string, **options); end
  end
end

# This class doesn't exert ownership over the specified socket, wraps a native ::IO.
#
# source://io-endpoint//lib/io/endpoint/socket_endpoint.rb#10
class IO::Endpoint::SocketEndpoint < ::IO::Endpoint::Generic
  # @return [SocketEndpoint] a new instance of SocketEndpoint
  #
  # source://io-endpoint//lib/io/endpoint/socket_endpoint.rb#11
  def initialize(socket, **options); end

  # source://io-endpoint//lib/io/endpoint/socket_endpoint.rb#27
  def bind(&block); end

  # source://io-endpoint//lib/io/endpoint/socket_endpoint.rb#35
  def connect(&block); end

  # source://io-endpoint//lib/io/endpoint/socket_endpoint.rb#21
  def inspect; end

  # Returns the value of attribute socket.
  #
  # source://io-endpoint//lib/io/endpoint/socket_endpoint.rb#25
  def socket; end

  # source://io-endpoint//lib/io/endpoint/socket_endpoint.rb#17
  def to_s; end
end

# source://io-endpoint//lib/io/endpoint/wrapper.rb#188
class IO::Endpoint::ThreadWrapper < ::IO::Endpoint::Wrapper
  # source://io-endpoint//lib/io/endpoint/wrapper.rb#189
  def async(&block); end
end

# source://io-endpoint//lib/io/endpoint/version.rb#8
IO::Endpoint::VERSION = T.let(T.unsafe(nil), String)

# source://io-endpoint//lib/io/endpoint/wrapper.rb#9
class IO::Endpoint::Wrapper
  include ::Socket::Constants

  # Bind to a local address and accept connections in a loop.
  #
  # source://io-endpoint//lib/io/endpoint/wrapper.rb#155
  def accept(server, timeout: T.unsafe(nil), linger: T.unsafe(nil), **options, &block); end

  # @raise [NotImplementedError]
  #
  # source://io-endpoint//lib/io/endpoint/wrapper.rb#33
  def async; end

  # Bind to a local address.
  #
  # @example
  #   socket = Async::IO::Socket.bind(Async::IO::Address.tcp("0.0.0.0", 9090))
  #
  # source://io-endpoint//lib/io/endpoint/wrapper.rb#105
  def bind(local_address, protocol: T.unsafe(nil), reuse_address: T.unsafe(nil), reuse_port: T.unsafe(nil), linger: T.unsafe(nil), bound_timeout: T.unsafe(nil), backlog: T.unsafe(nil), **options, &block); end

  # Establish a connection to a given `remote_address`.
  #
  # @example
  #   socket = Async::IO::Socket.connect(Async::IO::Address.tcp("8.8.8.8", 53))
  #
  # source://io-endpoint//lib/io/endpoint/wrapper.rb#43
  def connect(remote_address, local_address: T.unsafe(nil), linger: T.unsafe(nil), timeout: T.unsafe(nil), buffered: T.unsafe(nil), **options); end

  # source://io-endpoint//lib/io/endpoint/wrapper.rb#18
  def set_buffered(socket, buffered); end

  # source://io-endpoint//lib/io/endpoint/wrapper.rb#12
  def set_timeout(io, timeout); end

  class << self
    # source://io-endpoint//lib/io/endpoint/wrapper.rb#201
    def default; end
  end
end

# source://io-endpoint//lib/io/endpoint/wrapper.rb#94
IO::Endpoint::Wrapper::ServerSocket = Socket

IO::PRIORITY = T.let(T.unsafe(nil), Integer)
IO::READABLE = T.let(T.unsafe(nil), Integer)
class IO::TimeoutError < ::IOError; end
IO::WRITABLE = T.let(T.unsafe(nil), Integer)
