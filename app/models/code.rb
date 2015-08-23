class Code < ActiveRecord::Base
  belongs_to :language
  belongs_to :user

  validates :title, presence: true
  validates :code, presence: true
  validates :language, presence: true

  default_scope { order('created_at desc') }

  self.per_page = 20

  acts_as_taggable

  def highlighted_code
    # http://goo.gl/5sDQte
    unless Rouge::Lexer.find(language.name)
      lang = "text"
    else
      lang = language.name
    end

    formatter = Rouge.highlight(code, lang, 'html')

    "<div class='syntax'>#{formatter}</div>".html_safe
  end

  def self.update_tags
    Code.all.each do |code|
      code.tag_list.each do |tag|
        Tag.find_by(name: tag).increment!(:taggings_count)
      end
    end
  end

  def self.get_codes(user, tag)
    return where(users: { username: user }).joins(:user) if user
    return tagged_with(tag) if tag
    all
  end
end
