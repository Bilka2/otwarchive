module WranglingHelper
  def tag_counts_per_category
    counts = {}
    [Fandom, Character, Relationship, Freeform].each do |klass|
      counts[klass.to_s.downcase.pluralize.to_sym] = Rails.cache.fetch("/wrangler/counts/sidebar/#{klass}", race_condition_ttl: 10, expires_in: 1.hour) do # i18n-locale-independent
        TagQuery.new(type: klass.to_s, in_use: true, unwrangleable: false, unwrangled: true, has_posted_works: true).count
      end
    end
    counts[:UnsortedTag] = Rails.cache.fetch("/wrangler/counts/sidebar/UnsortedTag", race_condition_ttl: 10, expires_in: 1.hour) do # i18n-locale-independent
      UnsortedTag.count
    end
    counts
  end
end
