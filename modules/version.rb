# frozen_string_literal: true

require 'English'

module YuukiBot
  class << self
    attr_reader :version
  end
  @version = `git describe --long --tags --dirty --always`.strip
  @version = 'v4.5-unknown' unless $CHILD_STATUS.success?
end
