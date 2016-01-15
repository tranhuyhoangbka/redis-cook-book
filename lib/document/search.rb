class Document::Search
  def search sentence
    word_set_keys = ::Document::AddIndex.new.split_words_from_line(sentence).map{|w| "word:#{w}"}
    doc_ids = $redis.multi do
      $redis.zinterstore "zset_tmp", word_set_keys
      $redis.zrevrange "zset_tmp", 0, -1
    end.last
    return nil if doc_ids.blank?
    $redis.hmget "filenames", doc_ids
  end
end
