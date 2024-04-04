module FixPhraseapp
  def translate(*args)
    if to_be_translated_without_phraseapp?(args)
      kw_args = args.last.is_a?(Hash) ? args.pop : {}
      I18n.translate_without_phraseapp(*args, **kw_args)
    else
      phraseapp_delegate_for(args)
    end
  end
end

PhraseApp::InContextEditor::BackendService.prepend(FixPhraseapp)
