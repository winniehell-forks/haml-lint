require 'spec_helper'

RSpec.describe HamlLint::Linter::InlineScripts do
  include_context 'linter'

  context 'with no inline scripts' do
    let(:haml) { '%someTag' }

    it { should_not report_lint }
  end

  context 'with %script' do
    let(:haml) { <<-HAML }
      %script
        alert('Hello!');
    HAML

    it { should report_lint }
  end

  context 'with :javascript' do
    let(:haml) { <<-HAML }
      %someTag
        :javascript
          alert('Hello!');
    HAML

    it { should report_lint line: 2 }
  end
end
