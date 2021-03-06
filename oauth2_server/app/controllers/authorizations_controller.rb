class AuthorizationsController < ApplicationController
  before_filter :authenticate_user!

  rescue_from Rack::OAuth2::Server::Authorize::BadRequest do |e|
    @error = e
    render :error, :status => e.status
  end

  def new
    respond *authorize_endpoint.call(request.env)
  end

  def create
    respond *authorize_endpoint(:allow_approval).call(request.env)
  end

  private

  def respond(status, header, response)
    ["WWW-Authenticate"].each do |key|
      headers[key] = header[key] if header[key].present?
    end
    if response.redirect?
      redirect_to header['Location']
    else
      render :new
    end
  end

  def authorize_endpoint(allow_approval = false)
    Rack::OAuth2::Server::Authorize.new do |req, res|
      @site = Site.find(req.client_id) || req.bad_request!

      res.redirect_uri = @redirect_uri = req.verify_redirect_uri!(@site.redirect_uri)

      if allow_approval
        if params[:approve]
          case req.response_type
          when :code
            authorization_code = current_subject.authorization_codes.create(:site_id => @site.id, :redirect_uri => res.redirect_uri)
            res.code = authorization_code.token
          when :token
            res.access_token = current_subject.access_tokens.create(:site_id => @site.id).to_bearer_token
          end
          res.approve!
        else
          req.access_denied!
        end
      else
        @response_type = req.response_type
      end
    end
  end
end
