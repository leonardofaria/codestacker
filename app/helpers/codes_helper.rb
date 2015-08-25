module CodesHelper
	def styles_select_tag
		styles = %w[Base16 Colorful Github Molokai Monokai MonokaySublime ThankfulEyes]

		form_tag request.url, method: 'get', class: 'pure-form' do
	  	select_tag :style, options_for_select(styles, session[:style]), include_blank: 'style theme:', class: 'pure-input-1', onchange: 'this.form.submit();'
	  end
	end
end
