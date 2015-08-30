xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
	xml.channel do
		xml.title "codestacker"
		xml.title "codestacker: #{params[:user]}" unless params[:user].nil?
		xml.title "codestacker: #{params[:tag]}" unless params[:tag].nil?
		xml.description "we love code!"
		xml.description "codes by #{params[:user]}" unless params[:user].nil?
		xml.link root_url

		for code in @codes
			xml.item do
				xml.title code.title
				xml.author code.user.login
				xml.description simple_format(auto_link(code.description, :all)) + code.highlighted_code
				xml.pubDate code.created_at.to_s(:rfc822)
				xml.link code_url(code)
				xml.guid code_url(code)
			end
		end
	end
end
