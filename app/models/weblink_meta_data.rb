class WeblinkMetaData < MetaData

  attr_accessor :url

  def initialize(url)
    super()
    self.url = url
  end

  def external_reference
    url
  end

  def name
    url
  end

  def city
    'Web Links'
  end
end