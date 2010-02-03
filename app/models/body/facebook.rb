class Body::Facebook < Struct.new(:message, :href, :media, :name, :description, :caption)
  def media=(src)
    unless src.is_a?(String)
      self['media'] = src
    else
      self['media']=[{
        :type => 'image',
        :src => src,
        :href => self.href
      }]
    end
  end
  
  def to_hash
    ret_val = {}
    self.each_pair{|k,v|ret_val[k]=v}
    return ret_val
  end
end