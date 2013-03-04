module GridFu
  class Cell < Element
    def initialize(*args, &block)
      self.value = block
      self.key = args.first if args.first.is_a?(String) or args.first.is_a?(Symbol)

      config.tag = 'td'
      super(*args, &nil) # Bypass block evaling: in this case it's a value formatter
    end

    attr_reader :key, :value

    def to_html(member, index, &block)
      member_value = member.send(key) if key.present? and member.respond_to?(key)
      member_value = if value.is_a?(Proc)
        value.call(member_value, member, index)
      else
        member_value.to_s
      end

      super(*[member_value, member, index], &block)
    end

    protected
    def html_content(value, member, index)
      value
    end

    attr_writer :value
    attr_writer :key
  end
end
