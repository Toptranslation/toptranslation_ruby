require 'httmultiparty'

module Toptranslation
  class DocumentStoreRequest

    include HTTMultiParty
    attr_reader :response

    base_uri 'https://files.toptranslation.com'
  end
end
