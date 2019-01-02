defmodule SpaceAge do
  @type planet ::
          :mercury
          | :venus
          | :earth
          | :mars
          | :jupiter
          | :saturn
          | :uranus
          | :neptune

  @doc """
  Return the number of years a person that has lived for 'seconds' seconds is
  aged on 'planet'.
  """
  @spec age_on(planet, pos_integer) :: float
  def age_on(:earth, seconds), do: seconds / 31_557_600
  def age_on(:mercury, seconds), do: seconds / (0.2408467 * 31_557_600)
  def age_on(:venus, seconds), do: seconds / (0.61519726 * 31_557_600)
  def age_on(:mars, seconds), do: seconds / (1.8808158 * 31_557_600)
  def age_on(:jupiter, seconds), do: seconds / (11.862615 * 31_557_600)
  def age_on(:saturn, seconds), do: seconds / (29.447498 * 31_557_600)
  def age_on(:uranus, seconds), do: seconds / (84.016846 * 31_557_600)
  def age_on(:neptune, seconds), do: seconds / (164.79132 * 31_557_600)
end
