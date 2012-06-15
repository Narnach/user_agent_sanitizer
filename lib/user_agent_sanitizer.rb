# -*- encoding : utf-8 -*-
module UserAgentSanitizer
  extend self

  BRANDS=["nokia", "samsung", "SonyEricsson", "BlackBerry", "htc", "sec", 'gt', 'iphone']

  # Return a human-readable string representation of the user agent
  def sanitize_user_agent(string)
    user_agent = user_agent(string)
    return nil unless user_agent
    user_agent.to_s
  end

  # Return the UserAgent wrapper for the user agent string
  def user_agent(string)
    string = string.to_s
    return nil if string.empty?
    UserAgent.new(string)
  end

  class UserAgent
    attr_accessor :brand, :model, :user_agent

    def initialize(user_agent)
      @user_agent = user_agent.dup
    end

    def brand
      parse! unless parsed?
      @brand
    end

    def model
      parse! unless parsed?
      @model
    end

    def to_s
      "#{brand} #{model}".strip
    end

    protected

    def parse!
      return if @parsing
      begin
        @parsing = true
        parse
      ensure
        @parsing = false
      end
    end

    def parsed?
      @parsed
    end

    def parse
      result = self.basic_user_agent_recognizer
      if result
        result.gsub!(/^SAMSUNG/i, 'Samsung')
        result.gsub!(/^GT/i, 'Samsung GT')
        result.gsub!(/^Samsung GT\s+/i, 'Samsung GT-')
        result.gsub!(/^Desire(_\w+)/i, 'HTC Desire')
        result.gsub!(/^iPhone/i, 'Apple iPhone')
        result = "SonyEricsson #{$1}" if result =~ /^SonyEricsson(\w+)/i
        result.strip!
        result.squeeze!(" ")
        brand, *model_ary = *result.split(" ")
        @brand ||= brand
        @model ||= model_ary.join(" ")
      end
      self
    end

    def basic_user_agent_recognizer
      string = @user_agent.dup
      case string
      when /(Mac OS X) (\d+([_.]\d+)+)/
        @brand = 'Apple'
        @model = "#{$1} #{$2.gsub("_", ".")}"
        return nil
      when /(LG|sagem)[\-\/](\w+)/i
        return "#{$1} #{$2}"
      when /(MSIE) (\d+(\.\d+)*)/
        @brand = 'Microsoft'
        @model = "Internet Explorer #{$2}"
        return nil
      when /(Blackberry) ?(\d+)/i
        return "#{$1} #{$2}"
      when /(HTC)[_\/]([a-z0-9]+)?/i
        return [$1, $2].compact.join(" ")
      when /(Samsung)[\/\-]([a-z0-9]+)([\/\-]([a-z0-9]+))?/i
        return ['Samsung', $2, $4].compact.join(" ")
      when /\((Linux; U; Android.*)\)/
        return $1.split(";").last.split("/").first.gsub(/build/i, "").strip
      when /(iPod)/
        @brand = 'Apple'
        @model = 'iPod'
        return nil
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
end
