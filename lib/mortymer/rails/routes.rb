# frozen_string_literal: true

module Mortymer
  module Rails
    # This module is in charge of making each registered Morty Endpoint
    # routeable through rails
    class Routes
      def initialize(drawer)
        @drawer = drawer
      end

      def mount_morty_endpoints
        Morty::EndpointRegistry.registry.each do |endpoint|
          mount_endpoint(endpoint)
        end
      end

      def mount_controllers
        Morty::EndpointRegistry.registry.each do |endpoint|
          mount_controller(endpoint)
        end
      end

      private

      def mount_controller(endpoint)
        return unless endpoint.routeable?

        @drawer.send(
          endpoint.http_method,
          endpoint.path,
          to: "#{endpoint.controller_name.gsub(/_controller$/, "")}##{endpoint.action}",
          as: "#{endpoint.http_method}_#{endpoint.api_name}"
        )
      end

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
          @drawer.get path, to: "morty/rails/endpoint_wrapper#handle", defaults: defaults, constraints: constraints
        when :post
          @drawer.post path, to: "morty/rails/endpoint_wrapper#handle", defaults: defaults, constraints: constraints
        when :put
          @drawer.put path, to: "morty/rails/endpoint_wrapper#handle", defaults: defaults, constraints: constraints
        when :delete
          @drawer.delete path, to: "morty/rails/endpoint_wrapper#handle", defaults: defaults, constraints: constraints
        end
      end
    end
  end
end
