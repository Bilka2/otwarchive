PhraseApp::InContextEditor.configure do |config|
  # Enable or disable the In-Context-Editor in general
  if ENV['AO3_PHRASE_APP'] == 'true' || ArchiveConfig.PHRASEAPP_ENABLE == 'true' then
    config.enabled = true 
  else 
    config.enabled = true
  end

  # Configure with your project id and account id. You can find the
  # project id in your project settings and account id in your account
  # settings (https://app.phrase.com/)
  config.project_id = "47f2a1b0cf81df327878c6d89cee7af3"
  config.account_id = "foo"

  # Configure an array of key names that should not be handled
  # by the In-Context-Editor.
  config.ignored_keys = ["number.*", "faker.*"]

  # Phrase uses decorators to generate a unique identification key
  # in context of your document. However, this might result in conflicts
  # with other libraries (e.g. client-side template engines) that use a similar syntax.
  # If you encounter this problem, you might want to change this decorator pattern.
  # More information: https://help.phrase.com/hc/en-us/articles/5784095916188-In-Context-Editor-Strings-
  # config.prefix = "{{__"
  # config.suffix = "__}}"
end
