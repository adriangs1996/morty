# frozen_string_literal: true
# typed: true

class InnerResponse < T::Struct
  const :message, String
end

class Response < T::Struct
  const :inner, InnerResponse
end

class GetDependenciesConcreteInput < T::Struct
  const :message, String
  const :age, Integer
end
