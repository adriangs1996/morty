# frozen_string_literal: true

module Morty
  module Rails
    # This controller acts as a wrapper for Morty endpoints, handling param conversion
    # and response rendering
    class EndpointWrapperController < ::ActionController::Base
      def handle
        endpoint_class = request.env["morty.endpoint_class"]
        controller_class = endpoint_class.controller_class
        # If the controller is using Morty::DependenciesDsl this
        # should fire the Dependency Injection Engine
        handler = controller_class.new

        # Build input from params
        input_class = endpoint_class.input_class
        input = input_class.new(params.to_unsafe_h)

        # Call the endpoint
        output = handler.send(endpoint_class.action, input)

        # Render the response
        render json: output.to_h, status: :ok
      end
    end
  end
end
