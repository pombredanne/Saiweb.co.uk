require './plugins/pygments_code'

module BacktickCodeBlock
  include HighlightCode
  AllOptions = /([^\s]+)\s+(.+?)(https?:\/\/\S+)\s*(.+)?/i
  LangCaption = /([^\s]+)\s*(.+)?/i
  def render_code_block(input)
    @caption = nil
    @lang = nil
    @url = nil
    @title = nil
    input.gsub /^`{3} *([^\n]+)?\n(.+?)\n`{3}/m do
      options = $1
      str = $2

      if options =~ AllOptions
        @lang = $1
        @caption = "<figcaption><span>#{$2}</span><a href='#{$3}'>#{$4 || 'link'}</a></figcaption>"
      elsif options =~ LangCaption
        @lang = $1
        @caption = "<figcaption><span>#{$2}</span></figcaption>"
      end

      if str.match(/\A {4}/)
        str = str.gsub /^ {4}/, ''
      end
      if @lang.nil? || @lang == 'plain'
        code = tableize_code(str.gsub('<','&lt;').gsub('>','&gt;'))
        "<figure role=code>#{@caption}#{code}</figure>"
      else
        if @lang.include? "-raw"
          raw = "``` #{@lang.sub('-raw', '')}\n"
          raw += str
          raw += "\n```\n"
        else
          code = highlight(str, @lang)
          "<figure role=code>#{@caption}#{code}</figure>"
        end
      end
    end
  end
end
