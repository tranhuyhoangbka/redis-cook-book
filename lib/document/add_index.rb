class Document::AddIndex
  STOP_WORDS = %W(fuck suck)

  def add_doc_ids_to_word_set filename
    doc_id = add_or_load_doc_id filename
    file = File.open filename
    file.each_line do |l|
      split_words_from_line(l).each do |w|
        add_word w, doc_id
      end
    end
  end

  def split_words_from_line line
    line.strip.split(/ |,|;|\(|\)|\?|\$|&|:|'|"|\/|!|@|%/).map(&:strip).compact
      .select{|w| w.length > 2 && !w.in?(STOP_WORDS)}
  end

  private
  def add_word word, doc_id
    $redis.zincrby "word:#{word}", 1, doc_id
  end

  def add_or_load_doc_id filename
    unless doc_id = $redis.hget("documents", filename)
      doc_id = $redis.incr "next_document_id"
      $redis.hset "documents", filename, doc_id
      $redis.hset "filenames", doc_id, filename
    end
    doc_id
  end
end
