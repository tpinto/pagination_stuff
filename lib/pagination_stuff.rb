module PaginationStuff
  # intended to:
  # ActionController::Base.send :extend, PaginationStuff::ControllerStuff
  module ControllerStuff
    def pagination_stuff(*actions)
      opts = (Hash === actions.last ? actions.pop : {:limit => 5})
      define_method "set_pagination_vars" do
        @limit = (params[:limit] || opts[:limit]).to_i
        @offset = (params[:offset] || 0).to_i

        @pagination_stuff = {
          :limit => @limit,
          :offset => @offset
        }
      end

      protected :set_pagination_vars

      before_filter :set_pagination_vars, :only => actions
    end
  end

  # intended to:
  # ActionView::Base.send :include, PaginationStuff::ViewStuff::ClassMethods
  module ViewStuff
    def pagination_stuff(size, offset, limit)
      return "" if [size,offset,limit].include?(nil)
      
      out = ""
      
      prev_offset = offset - limit
      prev_offset = nil if prev_offset <= 0
      
      if offset > 0
        prev_link = link_to("&larr;&nbsp;prev", :offset => prev_offset, :limit => limit)
      end

      if size > 0 and size >= limit
        next_link = link_to("next&nbsp;&rarr;", :offset => offset+limit, :limit => limit)
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