class InvalidXmlContentError < StandardError
  def initialize(message)
    super(message)
  end
end