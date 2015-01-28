class Breadcrumbs
  module Render
    class MyAdmin < Base # :nodoc: all
      def render
        options = {
          :class => "breadcrumbs"
        }.merge(default_options)

        tag(:div, options) do
          html_div = tag(:ul) do
            html = ""
            items = breadcrumbs.items
            size = items.size

            items.each_with_index do |item, i|
              html << render_item(item, i, size)
            end

            html
          end
          html_div << tag(:div, :class => "close-bread") do
            tag(:a, :href => "#") do 
              tag(:i, :class => "icon-remove")
            end
          end
          html_div
        end
      end

      def render_item(item, i, size)
        css = []
        css << "first" if i == 0
        css << "last" if i == size - 1
        css << "item-#{i}"

        text, url, options = *item
        text = wrap_item(url, CGI.escapeHTML(text), options)
        text << tag(:i, {:class => "icon-angle-right"}) unless i == size - 1
        
        tag(:li, text, :class => css.join(" "))
      end
    end
  end
end