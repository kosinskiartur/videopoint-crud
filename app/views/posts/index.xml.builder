xml.instruct!

xml.Posts do
  @posts.each do |post|
    xml.Post do
      xml.Identifier post.id
      xml.Title post.title
    end
  end
end
