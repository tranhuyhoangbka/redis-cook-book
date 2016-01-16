class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  def add_book book
    $redis.sadd "books:#{self.id}", book.id
  end

  def books
    book_ids = $redis.smembers "books:#{self.id}"
    Book.where id: book_ids
  end

  def delbook book
    $redis.srem "books:#{self.id}", book.id
  end

  def common user
    book_ids = $redis.sinter "books:#{self.id}", "books:#{user.id}"
    Book.where id: book_ids
  end
end
