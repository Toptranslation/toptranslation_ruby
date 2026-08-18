require 'json'
require 'securerandom'
require 'rest-client'
require 'toptranslation/client'
require 'toptranslation/connection'
require 'toptranslation/resource/document'
require 'toptranslation/resource/document_list'
require 'toptranslation/resource/project_document_list'
require 'toptranslation/resource/locale_list'
require 'toptranslation/resource/locale'
require 'toptranslation/resource/order_list'
require 'toptranslation/resource/order'
require 'toptranslation/resource/project'
require 'toptranslation/resource/project_list'
require 'toptranslation/resource/quote'
require 'toptranslation/resource/reference_document'
require 'toptranslation/resource/translation'
require 'toptranslation/resource/translation_list'
require 'toptranslation/resource/upload'
require 'toptranslation/resource/user'

module Toptranslation
  # Raised when the removed email/password sign-in is used — the API only
  # accepts static access tokens since authentication moved to the
  # Toptranslation auth service.
  class SignInRemovedError < StandardError; end

  def self.new(options)
    Toptranslation::Client.new(options)
  end
end
