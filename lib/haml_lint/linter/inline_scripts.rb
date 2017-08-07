module HamlLint
  # Detects use of inline `script` tags
  class Linter::InlineScripts < Linter
    include LinterRegistry

    MESSAGE = 'Do not use inline script tags'.freeze

    def visit_tag(node)
      if node.tag_name == 'script' && !node.text.strip.empty?
        record_lint(node, MESSAGE)
      else
        puts node.tag_name
        puts node.text.strip.empty?
      end
    end
  end
end
