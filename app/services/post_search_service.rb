class PostSearchService
  def self.search(current_post, query)
    post_ids = Rails.cache.fetch("post_search/#{ query}", expires_in: 1.hours) do
      current_post.where("title like '%#{ query } %' ").map(&:id)
    end
    current_post.where(id: post_ids)
  end
end
