module PaginationStuff
  # intended to:
  # ActionController::Base.send :extend, PaginationStuff::ControllerStuff
  module ControllerStuff
    def pagination_stuff(*actions)
      opts = (Hash === actions.last ? actions.pop : {:limit => 5})
      define_method "set_pagination_vars" do
        @pagination_limit = (params[:limit] || opts[:limit]).to_i
        @pagination_page = (params[:page] || 1).to_i
        
        @pagination_offset = (@pagination_page*@pagination_limit) - @pagination_limit

        @pagination_stuff = {
          :limit =>   @pagination_limit,
          :offset =>  @pagination_offset
        }
      end

      protected :set_pagination_vars

      before_filter :set_pagination_vars, :only => actions
    end
  end

  # intended to:
  # ActionView::Base.send :include, PaginationStuff::ViewStuff::ClassMethods
  module ViewStuff
    def pagination_stuff(array)
      return "" if array.nil? or array.empty?
      
      out = ""
      
      offset  = @pagination_offset
      limit   = @pagination_limit
      page    = @pagination_page
      size = array.size
      
      prev_page = @pagination_page-1
      next_page = @pagination_page+1

      if @pagination_page > 1
        prev_link = link_to("&larr;&nbsp;prev", :page => (prev_page > 1 ? prev_page : nil), :limit => (params[:limit] ? limit : nil))
      end

      if size > 0 and size >= limit
        next_link = link_to("next&nbsp;&rarr;", :page => @pagination_page+1, :limit => (params[:limit] ? limit : nil))
      end
      
      out << prev_link if prev_link
      
      if prev_link and next_link
        out << "&nbsp;&bull;&nbsp;"
      end

      out << next_link if next_link

      return out
    end
  end
end