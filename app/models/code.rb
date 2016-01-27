class Code < ActiveRecord::Base
  belongs_to :language
  belongs_to :user

  has_many :comments, dependent: :destroy
  accepts_nested_attributes_for :comments, reject_if: :all_blank

  validates :title, presence: true
  validates :code, presence: true
  validates :language, presence: true

  default_scope { order('created_at desc') }

  self.per_page = 20

  acts_as_taggable

  def markdown_description
     options = {
      filter_html: true,
      hard_wrap: true,
      link_attributes: { rel: 'nofollow', target: "_blank" },
      space_after_headers: true,
      fenced_code_blocks: true
    }

    extensions = {
      autolink: true,
      highlight: true,
      strikethrough: true,
      quote: true,
      no_images: true,
      no_styles: true,
      prettify: true,
      superscript: true,
      footnotes: true,
      tables: true
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)
    markdown.render(description).html_safe
  end

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

  def self.get_codes(current_user, user, tag)
    return where(users: { username: user }).joins(:user) if !current_user.nil? and current_user.username == user
    return where(users: { username: user }, privated: false).joins(:user) if user
    return tagged_with(tag) if tag
    return all.flatten.find_all { |code| code.user.username == current_user.username || code.privated == false } unless current_user.nil?
    all.where(privated: false)
  end

  def to_param
    "#{self.id}-#{self.title.parameterize}"
  end
end
