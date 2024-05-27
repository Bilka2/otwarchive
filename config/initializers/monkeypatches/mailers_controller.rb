module MailersController
  extend ActiveSupport::Concern

  included do
    # Hide the dev mark in mailer previews.
    skip_rack_dev_mark
  end
end
module ViewMailersController
  def self.prepended(base)
    # Use modified email view so it can include the phrase in context editor
    base.prepend_view_path Rails.root.join('test', 'mailers', 'previews')
  end
end
Rails.application.config.after_initialize do
  ::Rails::MailersController.prepend ViewMailersController
  ::Rails::MailersController.include MailersController
end
