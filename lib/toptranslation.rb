require 'rest-client'
require 'toptranslation/api/api_client'
require 'toptranslation/api/api_connection'
require 'toptranslation/document_store/document_store_request'
require 'toptranslation/downloads/download'
require 'toptranslation/locales/locale_list'
require 'toptranslation/locales/locale'
require 'toptranslation/orders/order_list'
require 'toptranslation/orders/order'
require 'toptranslation/quotes/quote'
require 'toptranslation/reference_documents/reference_document'
require 'toptranslation/translations/translation'
require 'toptranslation/uploads/upload'
require 'toptranslation/users/user'

module Toptranslation
  def self.new(options)
    Toptranslation::ApiClient.new(options)
  end
end
