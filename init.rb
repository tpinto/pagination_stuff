require 'pagination_stuff'

ActionController::Base.send :extend,  PaginationStuff::ControllerStuff
ActionView::Base.send       :include, PaginationStuff::ViewStuff