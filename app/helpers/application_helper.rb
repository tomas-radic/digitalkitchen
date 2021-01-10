module ApplicationHelper
  def label_with_error(form:, attr_name:, text:, css_classes: "")
    form.label attr_name, text, class: "#{css_classes} #{'text-danger' if form.object.errors&.messages&.dig(attr_name)&.any?}".strip
  end


  def short_date(timestamp)
    timestamp&.strftime("%e-%b-%Y") || "-"
  end


  def short_time(timestamp)
    timestamp&.strftime("%e-%b-%Y %k:%M:%S") || "-"
  end
end
