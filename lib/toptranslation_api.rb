require 'json'
require 'rest-client'
require 'net/http/uploadprogress'
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
require 'toptranslation/resource/string_list'
require 'toptranslation/resource/string'
require 'toptranslation/resource/translation'
require 'toptranslation/resource/translation_list'
require 'toptranslation/resource/upload'
require 'toptranslation/resource/user'

module Toptranslation
  def self.new(options)
    Toptranslation::Client.new(options)
  end
end
