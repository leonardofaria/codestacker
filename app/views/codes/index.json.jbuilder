json.array!(@codes) do |code|
  json.extract! code, :id, :title, :code, :language_id, :description, :privated
  json.url code_url(code, format: :json)
end
