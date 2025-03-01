# frozen_string_literal: true

module Morty
  module Rails
    # This module is in charge of making each registered Morty Endpoint
    # routeable through rails
    module Routes
      def mount_morty_endpoints
        Morty::EndpointRegistry.registry.each do |endpoint|
          mount_endpoint(endpoint)
        end
      end

      private

      def mount_endpoint(endpoint)
        return unless endpoint.routeable?

        path = endpoint.path || endpoint.infer_path_from_class

        # Store the endpoint class in the request env for the wrapper to access
        defaults = { controller: "morty/rails/endpoint_wrapper", action: "handle" }
        constraints = lambda do |request|
          request.env["morty.endpoint_class"] = endpoint
          true
        end

        case endpoint.http_method
        when :get
          get path, to: "morty/rails/endpoint_wrapper#handle", defaults: defaults, constraints: constraints
        when :post
          post path, to: "morty/rails/endpoint_wrapper#handle", defaults: defaults, constraints: constraints
        when :put
          put path, to: "morty/rails/endpoint_wrapper#handle", defaults: defaults, constraints: constraints
        when :delete
          delete path, to: "morty/rails/endpoint_wrapper#handle", defaults: defaults, constraints: constraints
        end
      end
    end
  end
end
