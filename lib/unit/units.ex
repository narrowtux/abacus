defmodule Abacus.Units do
  use Abacus.UnitSystem

  # Temperature
  unit :kelvin, :temperature, 1
  unit :fahrenheit, :temperature, 1.8, 459.67
  unit :celsius, :temperature, 1, 273.15

  # Distance
  unit :meter, :distance, 1
  unit :inch, :distance, 39.3701
  unit :foot, :distance, 3.28084
  unit :yard, :distance, 1.09361
  unit :mile, :distance, 0.000621371
  unit :inch, :foot, 12
  unit :foot, :yard, 3
  unit :yard, :mile, 1760

  # Volume
  unit :liter, :volume, 1
  unit :us_cup, :volume, 4.16667

  convert_all
end
