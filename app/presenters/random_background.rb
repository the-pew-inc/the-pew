
class RandomBackground

  # This method shares the color code from `AvatarPresenter` but does not use
  # the user initials to select the background color. This method uses `rand`
  # to randomly select a backgroud value from the `colors` array.
  def self.background
    colors = [
      '#00AA55', '#009FD4', '#B381B3', '#939393', '#E3BC00',
      '#D47500', '#DC2A2A', '#696969', '#ff0000', '#ff80ed',
      '#407294', '#133337', '#065535', '#c0c0c0', '#5ac18e',
      '#666666', '#f7347a', '#576675', '#696966', '#008080',
      '#ffa500', '#40e0d0', '#0000ff', '#003366', '#fa8072',
      '#800000'
    ]
    colors[rand(colors.count - 1)]
  end
end