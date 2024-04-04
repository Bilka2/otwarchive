PhraseApp::InContextEditor.configure do |config|
  # Enable or disable the In-Context-Editor in general
  if ENV['AO3_PHRASE_APP'] == 'true' || ArchiveConfig.PHRASEAPP_ENABLE == 'true' then
    config.enabled = true 
  else 
    config.enabled = true
  end

  # Fetch your project id after creating your first project
  # in Translation Center.
  # You can find the project id in your project settings
  # page (https://phraseapp.com/projects)
  config.project_id = "47f2a1b0cf81df327878c6d89cee7af3"

  # You can create and manage access tokens in your profile settings
  # in Translation Center or via the Authorizations API
  # (http://docs.phraseapp.com/api/v2/authorizations/).
  config.account_id = "foo"

  # PhraseApp uses decorators to generate a unique identification key
  # in context of your document. However, this might result in conflicts
  # with other libraries (e.g. client-side template engines) that use a similar syntax.
  # If you encounter this problem, you might want to change this decorator pattern.
  # More information: http://docs.phraseapp.com/guides/in-context-editor/configure/
  # config.prefix = "{{__"
  # config.suffix = "__}}"
end
