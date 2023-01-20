# frozen_string_literal: true

require 'html/pipeline'
require 'slack_markdown/filters/ignorable_ancestor_tags'

module SlackMarkdown
  module Filters
    class ListFilter < ::HTML::Pipeline::Filter
      include IgnorableAncestorTags

      def call
        doc.search('.//text()').each do |node|
          content = node.to_html
          next if has_ancestor?(node, ignored_ancestor_tags)
          next unless content.include?('-')

          html = list_filter(content)
          next if html == content

          node.replace(html)
        end
        doc
      end

      def list_filter(text)
        text.gsub(LIST_PATTERN) do
          "<li>#{Regexp.last_match(1)}</li>"
        end.tap do |s|
          s[s.index('<li>'), 4] = '<ul><li>'
          s[s.rindex('</li>'), 5] = '</li></ul>'
        end
      end

      LIST_PATTERN = /(?<=^|\W)\ *\-\s+(.+)\n?(?=\W|$)/.freeze
    end
  end
end
