module SubscriptionsHelper

  # display_price - A view helper method for formatting and displaying prices.
  #
  # Parameters:
  # - price: A decimal number representing the price.
  #
  # Returns:
  # - If the decimal part of the price is 0, returns the price as an integer.
  # - If the decimal part of the price is not 0, returns the price as a decimal number with two decimal places.
  #
  # Examples:
  #   display_price(4.0)
  #   #=> 4
  #
  #   display_price(23.0)
  #   #=> 23
  #
  #   display_price(22.90)
  #   #=> 22.90
  #
  #   display_price(12.99)
  #   #=> 12.99
  def price_display(price)
    if price == price.to_i
      price.to_i
    else
      price.round(2)
    end
  end

end
