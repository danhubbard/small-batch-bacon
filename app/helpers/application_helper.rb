module ApplicationHelper
  # ... existing methods ...

  def format_weight(weight_in_grams)
    if weight_in_grams < 1000
      formatted_weight = number_with_precision(weight_in_grams, precision: 0)
      unit = 'g'
    else
      formatted_weight = number_with_precision(weight_in_grams / 1000.0, precision: 0)
      unit = 'kg'
    end
    "#{formatted_weight}#{unit}"
  end
end
