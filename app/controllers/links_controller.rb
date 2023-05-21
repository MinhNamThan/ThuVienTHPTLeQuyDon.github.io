class LinksController < ApplicationController
    before_action :logged_in_user, only: [:edit, :update]
    def index
        @links = Link.asc_describe
    end
end
