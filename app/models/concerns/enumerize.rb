module Enumerize

  def enumerize(column_name, with: [])

    enum_values = {}

    with.each do |enum_value|
      enum_values[enum_value] = enum_value.to_s

      define_method column_name do
        super().to_sym
      end
    end

    enum column_name => enum_values
  end
end
