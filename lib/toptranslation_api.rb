require 'json'
require 'rest-client'
require 'toptranslation_api/api/client'
require 'toptranslation_api/api/connection'
require 'toptranslation_api/documents/document'
require 'toptranslation_api/documents/document_list'
require 'toptranslation_api/documents/project_document_list'
require 'toptranslation_api/locales/locale_list'
require 'toptranslation_api/locales/locale'
require 'toptranslation_api/orders/order_list'
require 'toptranslation_api/orders/order'
require 'toptranslation_api/projects/project'
require 'toptranslation_api/projects/project_list'
require 'toptranslation_api/quotes/quote'
require 'toptranslation_api/reference_documents/reference_document'
require 'toptranslation_api/translations/translation'
require 'toptranslation_api/translations/translation_list'
require 'toptranslation_api/uploads/upload'
require 'toptranslation_api/users/user'

module ToptranslationApi
  def self.new(options)
    ToptranslationApi::Client.new(options)
  end
end
