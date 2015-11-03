require 'test_helper'
require 'json_data/data'

module JSONData
  class DataTest < Minitest::Test
    def test_respond_to_data_attr
      assert_respond_to klass, :data_attr
    end

    def test_work_with_nil_data_source
      assert_instance_of klass, klass.new(data_source: nil)
    end

    def test_work_with_json_data_source
      assert_instance_of klass, klass.new(data_source: json_data_source)
    end

    def test_work_with_hash_data_source
      assert_instance_of klass, klass.new(data_source: hash_data_source)
    end

    def test_work_with_invalid_data_source
      assert_raises JSON::ParserError do
        klass.new(data_source: invalid_data_source)
      end
    end

    def test_data_attr_direct_delegation
      klass.data_attr :foo

      assert_equal 'bar', subject.foo
    end

    def test_data_attr_mapped_field
      klass.data_attr :foo, as: :bax

      refute_respond_to subject, :foo
      assert_equal 'bar', subject.bax
    end

    def test_data_attr_data_class
      klass.data_attr :foo, data_class: OpenStruct

      assert_instance_of OpenStruct, subject.foo
    end

    def test_valid_true_no_required_attrs
      assert subject.valid?, 'subject should be valid'
    end

    def test_valid_true_with_required_attr
      klass.data_attr :foo, required: true

      assert subject.valid?, 'subject should be valid'
    end

    def test_valid_false_require_attr_missing
      klass.data_attr :random, required: true

      refute subject.valid?, 'subject should be invalid'
    end

    private

    def klass
      @klass ||= Class.new { include JSONData::Data }
    end

    def subject
      @subject ||= klass.new(data_source: json_data_source)
    end

    def invalid_data_source
      @invalid_data_source ||= 'some random string'
    end

    def hash_data_source
      @hash_data_source ||= { foo: 'bar' }
    end

    def json_data_source
      @json_data_source ||= JSON.generate(hash_data_source)
    end
  end
end
