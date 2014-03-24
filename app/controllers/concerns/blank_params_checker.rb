module BlankParamsChecker
  def get_blank_params(params, *mandatory_fields)
    blank_params = []
    mandatory_fields.each do |field|
      blank_params << field.to_s if params[field].nil?
    end
    blank_params
  end

  def render_error
    render 'shared/errors', formats: [:json], status: :bad_request
  end
end
