class Search

  RESOURCES = %w(question answer comment user).freeze

  def self.search(q, resource='all')
    q = ThinkingSphinx::Query.escape(q) unless q.nil?

    if RESOURCES.include?(resource)
      resource.classify.constantize.search q
    else
      ThinkingSphinx.search q
    end
  end

end
