class IntercoolerSupport

  def initialize(controller)
    @controller = controller
  end

  def request?
    @controller.request.params['ic-request'] || ic_redirect?
  end

  def take_flash?
    @ic_redirect || !@controller.session[:ic_redirect].nil?
  end

  def trigger(event_name, *args)
    if @controller.response.headers['X-IC-Trigger']
      raise "Only one server side event can be triggered per request!"
    end
    @controller.response.headers['X-IC-Trigger'] = event_name
    @controller.response.headers['X-IC-Trigger-Data'] = args.to_json
  end

  def redirect_to(args)
    @controller.session[:ic_redirect] = true
    @controller.session[:ic_redirect_target] = @controller.request.params['ic-target-id']
    @controller.redirect_to(@controller.url_for(args))
  end

  def client_side_redirect(url)
    @controller.response.headers['X-IC-Redirect'] = url
  end

  def ic_redirect?
    if @ic_redirect.nil?
      @ic_redirect = @controller.session[:ic_redirect]
      @ic_redirect_target = @controller.session[:ic_redirect_target]
      @controller.session.delete(:ic_redirect)
      @controller.session.delete(:ic_redirect_target)
    end
    @ic_redirect
  end

  def push_url(url)
    @controller.response.headers['X-IC-PushURL'] = url
  end

  def current_target?(id)
    @controller.request.params['ic-target-id'] == id || @ic_redirect_target == id
  end

  def current_source?(id)
    @controller.request.params['ic-element-id'] == id
  end

  def before_request
    if take_flash?
      if @controller.flash.alert
        flash_alert(@controller.flash.alert)
        @controller.flash.delete(:alert)
      end
      if @controller.flash.notice
        flash_notice(@controller.flash.notice)
        @controller.flash.delete(:notice)
      end
    end
    if ic_redirect?
      push_url(@controller.request.url)
    end
  end

  def flash_alert(str)
    trigger('app.flash.alert', str)
  end

  def flash_notice(str)
    trigger('app.flash.notice', str)
  end

  def after_request
    if @controller.flash.now[:alert]
      flash_alert(@controller.flash.now[:alert])
    end
    if @controller.flash.now[:notice]
      flash_alert(@controller.flash.now[:notice])
    end
  end

end