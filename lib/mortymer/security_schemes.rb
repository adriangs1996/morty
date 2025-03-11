# frozen_string_literal: true

module Mortymer
  module SecuritySchemes
    # Define the Bearer Auth security scheme
    class Bearer
      def self.scheme(scopes = [].freeze)
        { BearerAuth: scopes }
      end

      def self.to_scheme
        {
          BearerAuth: {
            type: :http,
            scheme: :bearer
          }
        }
      end
    end

    # Define the API Key security scheme
    class ApiKey
      def self.scheme(scopes = [].freeze)
        { ApiKeyAuth: scopes }
      end

      def self.to_scheme(name: "X-API-Key", in: :header)
        {
          ApiKeyAuth: {
            type: :apiKey,
            name: name,
            in: binding.local_variable_get(:in) # Use binding because 'in' is a reserved word
          }
        }
      end
    end

    # Define the Basic Auth security scheme
    class Basic
      def self.scheme(scopes = [].freeze)
        { BasicAuth: scopes }
      end

      def self.to_scheme
        {
          BasicAuth: {
            type: :http,
            scheme: :basic
          }
        }
      end
    end

    # Define the OAuth2 security scheme
    class OAuth2
      def self.scheme(scopes = [].freeze)
        { OAuth2: scopes }
      end

      def self.to_scheme(flows: {})
        {
          OAuth2: {
            type: :oauth2,
            flows: flows || {
              implicit: {
                authorizationUrl: "/oauth/authorize",
                scopes: {
                  "read:api" => "Read access",
                  "write:api" => "Write access"
                }
              },
              password: {
                tokenUrl: "/oauth/token",
                scopes: {
                  "read:api" => "Read access",
                  "write:api" => "Write access"
                }
              }
            }
          }
        }
      end
    end
  end
end
