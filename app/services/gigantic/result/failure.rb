module Gigantic
  module Result
    class Failure < OpenStruct
      def success?
        false
      end
    end
  end
end

