class PostReport < Struct.new(:word_count, :word_histogram)
  def self.generate(post)
    PostReport.new(
      post.content.split.map { |word| word.gsub(/\w+/, '') }.count,
      post.content.split.map { |word| word.gsub(/\w+/, '') }.map(&:downcase).group_by { |word| word }
    )
  end
end
