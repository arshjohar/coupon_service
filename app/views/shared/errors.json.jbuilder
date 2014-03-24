json.errors do
  @blank_params.each { |field| json.set! field, "can't be blank" } if @blank_params.present?
  json.set! @invalid_param, @description if @invalid_param.present?
end
