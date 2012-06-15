# -*- encoding : utf-8 -*-
module UserAgentSanitizer
  extend self

  BRANDS=["nokia", "samsung", "SonyEricsson", "BlackBerry", "htc", "sec", 'gt', 'iphone']

  def sanitize_user_agent(string)
    string = string.to_s
    return nil if string.empty?
    result = basic_user_agent_recognizer(string)
    result.gsub!(/^SAMSUNG/i, 'Samsung')
    result.gsub!(/^GT/i, 'Samsung GT')
    result.gsub!(/^Samsung GT\s+/i, 'Samsung GT-')
    result.gsub!(/^Desire(_\w+)/i, 'HTC Desire')
    result = "SonyEricsson #{$1}" if result =~ /^SonyEricsson(\w+)/i
    result.strip!
    result.squeeze!(" ")
    result
  end

  protected

  def basic_user_agent_recognizer(string)
    case string
    when /(Mac OS X) (\d+_\d+_\d+)/
      return "#{$1} #{$2.gsub("_", ".")}"
    when /(LG|sagem)[\-\/](\w+)/i
      return "#{$1} #{$2}"
    when /(MSIE) (\d+(\.\d+)*)/
      return "#{$1} #{$2}"
    when /(Blackberry) ?(\d+)/i
      return "#{$1} #{$2}"
    when /(HTC)[_\/]([a-z0-9]+)?/i
      return [$1, $2].compact.join(" ")
    when /(Samsung)[\/\-]([a-z0-9]+)([\/\-]([a-z0-9]+))?/i
      return [$1, $2, $4].compact.join(" ")
    when /\((Linux; U; Android.*)\)/
      return $1.split(";").last.split("/").first.gsub(/build/i, "").strip
    when /(iPod)/
      return $1
    when /((#{BRANDS.join("|")}).*?)\//i
      result=$1

      result.gsub!(/build/i, "")
      result.gsub!(/-1/, "")
      result.gsub!(/-/, " ")

      if result=~/(.+?);/
        result = $1
      end

      if result=~/(\D+)([A-Z]+\d+)/
        result="#{$1} #{$2}"
      elsif result=~/(\D+)(\d+)/
        result="#{$1} #{$2}"
      end

      return result
    else
      return string
    end
  end
end
