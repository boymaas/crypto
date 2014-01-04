require 'sequel'
require 'sequel/extensions/pagination'

module Kaminari
  module Sequel
    
    def self.included(base)
    
      base.class_eval do
        alias :total_pages :page_count
        alias :limit_value :page_size
      end
      
      ::Sequel::DatasetPagination.class_eval do
        
        def paginate_with_safe_page(page_no, page_size, record_count=nil)
          page_no = page_no.to_i
          page_no = page_no == 0 ? 1 : page_no
          paginate_without_safe_page(page_no, page_size, record_count)
        end
        
        alias_method_chain :paginate, :safe_page
 
      end
 
    end
 
  end
end
 

Sequel::Dataset::Pagination.send(:include, Kaminari::Sequel)

# NOTE: loading the extention this way has no effect 
#       in rails production environment. Do not ask me why? Need to load the extention
#       manyally on the dataaset ...
# Sequel.extension :pagination
# CryptoTrader::DB.extension :pagination

# require 'pry'
# ::Sequel::DatasetPagination.pry
# Sequel::Dataset::Pagination.pry
