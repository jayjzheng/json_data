require 'test_helper'
require 'json_data/collection'

module JSONData
  class CollectionTest < Minitest::Test
    def test_respond_to_data_class
      assert_respond_to klass, :data_class
    end

    def test_work_with_json_data_source
      assert_instance_of klass, klass.new(data_source: json_data_source)
    end

    def test_work_with_array_data_source
      assert_instance_of klass, klass.new(data_source: array_data_source)
    end

    def test_work_with_invalid_data_source
      assert_raises JSON::ParserError do
        klass.new(data_source: invalid_data_source)
      end
    end

    def test_subject_is_enumerable
      assert_kind_of Enumerable, subject
    end

    def test_data_class_create_object
      subject.each { |e| assert_kind_of Temp, e }
    end

    def test_valid_true
      assert subject.valid?, 'subject should be valid'
    end

    def test_valid_false_empty
      subject.data_source = []

      refute subject.valid?, 'subject should be invalid'
    end

    def test_empty_true
      subject.data_source = []

      assert subject.empty?, 'subject should be empty'
    end

    def test_empty_false
      subject.data_source = array_data_source

      refute subject.empty?, 'subject should not be empty'
    end

    private

    class Temp
      include JSONData::Data
    end

    def klass
      @klass ||= Class.new do
        include JSONData::Collection

        data_class Temp
      end
    end

    def subject
      @subject ||= klass.new(data_source: json_data_source)
    end

    def invalid_data_source
      @invalid_data_source ||= "some random string"
    end

    def array_data_source
      @array_data_source ||= [{foo: 'bar'}, {baz: 'qux'}]
    end

    def json_data_source
      @json_data_source ||= JSON.generate(array_data_source)
    end
  end
end
