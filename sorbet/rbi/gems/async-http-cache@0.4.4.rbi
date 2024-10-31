# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `async-http-cache` gem.
# Please instead update this file by running `bin/tapioca gem async-http-cache`.


# source://async-http-cache//lib/async/http/cache/version.rb#6
module Async; end

# source://async-http-cache//lib/async/http/cache/version.rb#7
module Async::HTTP; end

# source://async-http-cache//lib/async/http/cache/version.rb#8
module Async::HTTP::Cache; end

# source://async-http-cache//lib/async/http/cache/body.rb#16
module Async::HTTP::Cache::Body
  class << self
    # source://async-http-cache//lib/async/http/cache/body.rb#20
    def wrap(response, &block); end
  end
end

# source://async-http-cache//lib/async/http/cache/body.rb#18
Async::HTTP::Cache::Body::ETAG = T.let(T.unsafe(nil), String)

# source://async-http-cache//lib/async/http/cache/body.rb#17
Async::HTTP::Cache::Body::TRAILER = T.let(T.unsafe(nil), String)

# Implements a general shared cache according to https://www.rfc-editor.org/rfc/rfc9111
#
# source://async-http-cache//lib/async/http/cache/general.rb#18
class Async::HTTP::Cache::General < ::Protocol::HTTP::Middleware
  # @return [General] a new instance of General
  #
  # source://async-http-cache//lib/async/http/cache/general.rb#40
  def initialize(app, store: T.unsafe(nil)); end

  # @return [Boolean]
  #
  # source://async-http-cache//lib/async/http/cache/general.rb#63
  def cacheable_request?(request); end

  # @return [Boolean]
  #
  # source://async-http-cache//lib/async/http/cache/general.rb#107
  def cacheable_response?(response); end

  # @return [Boolean]
  #
  # source://async-http-cache//lib/async/http/cache/general.rb#91
  def cacheable_response_headers?(headers); end

  # source://async-http-cache//lib/async/http/cache/general.rb#165
  def call(request); end

  # source://async-http-cache//lib/async/http/cache/general.rb#51
  def close; end

  # Returns the value of attribute count.
  #
  # source://async-http-cache//lib/async/http/cache/general.rb#48
  def count; end

  # source://async-http-cache//lib/async/http/cache/general.rb#57
  def key(request); end

  # Semantically speaking, it is possible for trailers to result in an uncacheable response, so we need to check for that.
  #
  # @return [Boolean]
  #
  # source://async-http-cache//lib/async/http/cache/general.rb#124
  def proceed_with_response_cache?(response); end

  # Returns the value of attribute store.
  #
  # source://async-http-cache//lib/async/http/cache/general.rb#49
  def store; end

  # Potentially wrap the response so that it updates the cache, if caching is possible.
  #
  # source://async-http-cache//lib/async/http/cache/general.rb#136
  def wrap(key, request, response); end
end

# source://async-http-cache//lib/async/http/cache/general.rb#22
Async::HTTP::Cache::General::AUTHORIZATION = T.let(T.unsafe(nil), String)

# Status codes of responses that MAY be stored by a cache or used in reply
# to a subsequent request.
#
# http://tools.ietf.org/html/rfc2616#section-13.4
#
# source://async-http-cache//lib/async/http/cache/general.rb#30
Async::HTTP::Cache::General::CACHEABLE_RESPONSE_CODES = T.let(T.unsafe(nil), Hash)

# source://async-http-cache//lib/async/http/cache/general.rb#19
Async::HTTP::Cache::General::CACHE_CONTROL = T.let(T.unsafe(nil), String)

# source://async-http-cache//lib/async/http/cache/general.rb#21
Async::HTTP::Cache::General::CONTENT_TYPE = T.let(T.unsafe(nil), String)

# source://async-http-cache//lib/async/http/cache/general.rb#23
Async::HTTP::Cache::General::COOKIE = T.let(T.unsafe(nil), String)

# source://async-http-cache//lib/async/http/cache/general.rb#24
Async::HTTP::Cache::General::SET_COOKIE = T.let(T.unsafe(nil), String)

# source://async-http-cache//lib/async/http/cache/response.rb#12
class Async::HTTP::Cache::Response < ::Protocol::HTTP::Response
  # @return [Response] a new instance of Response
  #
  # source://async-http-cache//lib/async/http/cache/response.rb#18
  def initialize(response, body); end

  # source://async-http-cache//lib/async/http/cache/response.rb#41
  def age; end

  # source://async-http-cache//lib/async/http/cache/response.rb#51
  def dup; end

  # source://async-http-cache//lib/async/http/cache/response.rb#37
  def etag; end

  # @return [Boolean]
  #
  # source://async-http-cache//lib/async/http/cache/response.rb#45
  def expired?; end

  # Returns the value of attribute generated_at.
  #
  # source://async-http-cache//lib/async/http/cache/response.rb#35
  def generated_at; end
end

# source://async-http-cache//lib/async/http/cache/response.rb#13
Async::HTTP::Cache::Response::CACHE_CONTROL = T.let(T.unsafe(nil), String)

# source://async-http-cache//lib/async/http/cache/response.rb#14
Async::HTTP::Cache::Response::ETAG = T.let(T.unsafe(nil), String)

# source://async-http-cache//lib/async/http/cache/response.rb#16
Async::HTTP::Cache::Response::X_CACHE = T.let(T.unsafe(nil), String)

# source://async-http-cache//lib/async/http/cache/store/memory.rb#9
module Async::HTTP::Cache::Store
  class << self
    # source://async-http-cache//lib/async/http/cache/store.rb#13
    def default; end
  end
end

# source://async-http-cache//lib/async/http/cache/store/vary.rb#11
Async::HTTP::Cache::Store::ACCEPT_ENCODING = T.let(T.unsafe(nil), String)

# source://async-http-cache//lib/async/http/cache/store/memory.rb#10
class Async::HTTP::Cache::Store::Memory
  # @return [Memory] a new instance of Memory
  #
  # source://async-http-cache//lib/async/http/cache/store/memory.rb#11
  def initialize(limit: T.unsafe(nil), maximum_size: T.unsafe(nil), prune_interval: T.unsafe(nil)); end

  # source://async-http-cache//lib/async/http/cache/store/memory.rb#45
  def close; end

  # Returns the value of attribute index.
  #
  # source://async-http-cache//lib/async/http/cache/store/memory.rb#49
  def index; end

  # source://async-http-cache//lib/async/http/cache/store/memory.rb#80
  def insert(key, request, response); end

  # source://async-http-cache//lib/async/http/cache/store/memory.rb#54
  def lookup(key, request); end

  # @return [Integer] the number of pruned entries.
  #
  # source://async-http-cache//lib/async/http/cache/store/memory.rb#90
  def prune; end
end

# source://async-http-cache//lib/async/http/cache/store/memory.rb#51
Async::HTTP::Cache::Store::Memory::IF_NONE_MATCH = T.let(T.unsafe(nil), String)

# source://async-http-cache//lib/async/http/cache/store/memory.rb#52
Async::HTTP::Cache::Store::Memory::NOT_MODIFIED = T.let(T.unsafe(nil), Protocol::HTTP::Response)

# source://async-http-cache//lib/async/http/cache/store/vary.rb#10
Async::HTTP::Cache::Store::VARY = T.let(T.unsafe(nil), String)

# source://async-http-cache//lib/async/http/cache/store/vary.rb#13
class Async::HTTP::Cache::Store::Vary
  # @return [Vary] a new instance of Vary
  #
  # source://async-http-cache//lib/async/http/cache/store/vary.rb#14
  def initialize(delegate, vary = T.unsafe(nil)); end

  # source://async-http-cache//lib/async/http/cache/store/vary.rb#19
  def close; end

  # Returns the value of attribute delegate.
  #
  # source://async-http-cache//lib/async/http/cache/store/vary.rb#23
  def delegate; end

  # source://async-http-cache//lib/async/http/cache/store/vary.rb#48
  def insert(key, request, response); end

  # source://async-http-cache//lib/async/http/cache/store/vary.rb#35
  def key_for(headers, vary); end

  # source://async-http-cache//lib/async/http/cache/store/vary.rb#39
  def lookup(key, request); end

  # source://async-http-cache//lib/async/http/cache/store/vary.rb#25
  def normalize(request); end
end

# source://async-http-cache//lib/async/http/cache/version.rb#9
Async::HTTP::Cache::VERSION = T.let(T.unsafe(nil), String)
