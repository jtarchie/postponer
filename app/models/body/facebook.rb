class Body::Facebook < Struct.new(:message, :href, :media, :name, :description, :caption)
  def media=(src)
    unless src.is_a?(String)
      self['media'] = src
    else
      unless src == ''
        self['media'] = [{
          :type => 'image',
          :src => src,
          :href => self.href
        }]
      else
        self['media'] = ''
      end
    end
  end
  
  def to_hash
    ret_val = {}
    self.each_pair{|k,v|ret_val[k]=v}
    ret_val.reject!{|k,v| v.blank?}
    return ret_val
  end
end