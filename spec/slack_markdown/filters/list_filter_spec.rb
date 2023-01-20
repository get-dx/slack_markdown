# frozen_string_literal: true

require 'spec_helper'

describe SlackMarkdown::Filters::ListFilter do
  subject do
    filter = SlackMarkdown::Filters::ListFilter.new(text)
    filter.call.to_s
  end

  context 'this is a list' do
    let(:text) do
      """- this
- is
- a
- list"""
    end

    it do
      should eq """<ul>
<li>this</li>
<li>is</li>
<li>a</li>
<li>list</li>
</ul>"""
    end
  end

  context 'content before the list' do
    let(:text) do
      """lorem ipsum is simply dummy text

        - this
        - is
        - a
        - list"""
    end

    it do
      should eq """lorem ipsum is simply dummy text

<ul>
<li>this</li>
<li>is</li>
<li>a</li>
<li>list</li>
</ul>"""
    end
  end

  context 'content after the list' do
    let(:text) do
      """- this
- is
- a
- list

lorem ipsum is simply dummy text"""
    end

    it do
      should eq """<ul>
<li>this</li>
<li>is</li>
<li>a</li>
<li>list</li>
</ul>
lorem ipsum is simply dummy text"""
    end
  end

  context 'content before and after the list' do
    let(:text) do
      """lorem ipsum is simply dummy text
   - this
- is
- a
- list

lorem ipsum is simply dummy text"""
    end

    it do
      should eq """lorem ipsum is simply dummy text
<ul>
<li>this</li>
<li>is</li>
<li>a</li>
<li>list</li>
</ul>
lorem ipsum is simply dummy text"""
    end
  end
end
