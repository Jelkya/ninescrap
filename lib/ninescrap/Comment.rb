require 'json'

class Comment
  attr_reader :self

  # date accessors
  def date=(date)
    @date=date
  end

  # author accessors
  def author=(author)
    @author=author
  end
  def author
    @author
  end
  
  def content=(content)
    @content=content
  end
  def content
    @content
  end

  def to_json(*args)
    json = {:author => "#{@author}", :content => "#{@content}", :date => "#{@date}"}
    JSON.generate(json,args)
  end

  def to_s
   "\"author\" : \"#{@author}\", \"content\" : \"#{@content}\", \"date\" : \"#{@date}\""
  end
end
