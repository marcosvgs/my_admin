module Paperclip
  class Rotator < Thumbnail
    
    attr_accessor :rotate
    
    def initialize file, options = {}, attachment = nil
      super
      @rotate = options[:rotate]
    end
    
    def transformation_command
      if rotate_command
        super.join(" ") + rotate_command
      else
        super
      end
    end
    
    def rotate_command
      unless @rotate.blank?
        " -background None -rotate #{@rotate} "
      end
    end
  end
end