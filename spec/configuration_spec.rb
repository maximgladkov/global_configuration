require 'spec_helper'

describe Configuration do
  describe ".data" do
    it "should read string value" do
      Configuration.create(key: 'test', data_string: 'Test string')
      Configuration.find('test').data.should eq('Test string')
    end

    it "should read float value" do
      Configuration.create(key: 'test', data_float: 3.14)
      Configuration.find('test').data.should eq(3.14)
    end

    it "should read integer value" do
      Configuration.create(key: 'test', data_integer: 12345)
      Configuration.find('test').data.should eq(12345)
    end

    it "should read boolean value" do
      Configuration.create(key: 'test', data_boolean: true)
      Configuration.find('test').data.should be_true
    end
  end

  describe ".data=" do
    it "should write string value" do
      Configuration.write('test', 'Test string')
      Configuration.find('test').data_string.should eq('Test string')
    end

    it "should write float value" do
      Configuration.write('test', 3.14)
      Configuration.find('test').data_float.should eq(3.14)
    end
    
    it "should write integer value" do
      Configuration.write('test', 12345)
      Configuration.find('test').data_integer.should eq(12345)
    end
    
    it "should write boolean value" do
      Configuration.write('test', true)
      Configuration.find('test').data_boolean.should eq(true)
    end
  end

  describe "#write" do
    it "should accept string key" do
      Configuration.write('test', 'Test string')
      Configuration.exists?(key: 'test').should be_true
    end

    it "should accept symbol key" do
      Configuration.write(:test, 'Test string')
      Configuration.exists?(key: 'test').should be_true
    end

    it "should return true if was successfull" do
      Configuration.write(:test, 'Test string').should be_true
    end

    it "should return false if there was a problem" do
      Configuration.write(nil, 'Test string').should be_false
    end

    it "should create new record if key was not found" do
      Configuration.write(:test, 'Test string')
      Configuration.count.should eq(1)
      Configuration.first.data_string.should eq('Test string')
    end

    it "should overwrite record if key was found" do
      Configuration.create(key: 'test', data_string: 'Test string')
      Configuration.write(:test, 'Test string 2')
      Configuration.where(key: 'test').count.should eq(1)
      Configuration.find('test').data_string.should eq('Test string 2')
    end

    it "should destroy record if value is nil" do
      Configuration.create(key: 'test')
      Configuration.write(:test, nil)
      Configuration.count.should eq(0)
    end
  end

  describe "#write!" do
    it "should raise error if key is nil" do
      expect { Configuration.write!(nil, 'Test string') }.to raise_error(ArgumentError)
    end

    it "should raise error if key is an empty string" do
      expect { Configuration.write!('', 'Test string') }.to raise_error(ArgumentError)
    end
  end

  describe "#[]=" do
    it "should accept string key" do
      Configuration['test'] = 'Test string'
      Configuration.exists?(key: 'test').should be_true
    end

    it "should accept symbol key" do
      Configuration[:test] = 'Test string'
      Configuration.exists?(key: 'test').should be_true
    end

    it "should raise error if key is nil" do
      expect { Configuration[nil] = 'Test string' }.to raise_error(ArgumentError)
    end

    it "should raise error if key is an empty string" do
      expect { Configuration[''] = 'Test string' }.to raise_error(ArgumentError)
    end

    it "should create new record if key was not found" do
      Configuration[:test] = 'Test string'
      Configuration.count.should eq(1)
      Configuration.first.data_string.should eq('Test string')
    end

    it "should overwrite record if key was found" do
      Configuration.create(key: 'test', data_string: 'Test string')
      Configuration[:test] = 'Test string 2'
      Configuration.where(key: 'test').count.should eq(1)
      Configuration.find('test').data_string.should eq('Test string 2')
    end

    it "should destroy record if value is nil" do
      Configuration.create(key: 'test')
      Configuration[:test] = nil
      Configuration.count.should eq(0)
    end
  end

  describe "#read" do
    it "should accept string key" do
      Configuration.create(key: 'test', data_string: 'Test string')
      Configuration.read('test').should eq('Test string')
    end

    it "should accept symbol key" do
      Configuration.create(key: 'test', data_string: 'Test string')
      Configuration.read(:test).should eq('Test string')
    end

    it "should return nil if key is blank" do
      Configuration.read(nil).should be_nil
    end
  end

  describe "#[]" do
    it "should accept string key" do
      Configuration.create(key: 'test', data_string: 'Test string')
      Configuration['test'].should eq('Test string')
    end

    it "should accept symbol key" do
      Configuration.create(key: 'test', data_string: 'Test string')
      Configuration[:test].should eq('Test string')
    end

    it "should return nil if key is blank" do
      Configuration[nil].should be_nil
    end
  end

  describe "#delete" do
    it "should destroy record" do
      Configuration.create(key: 'test')
      Configuration.delete(:test)
      Configuration.count.should eq(0)
    end

    it "should return true if was successfull" do
      Configuration.create(key: 'test')
      Configuration.delete(:test).should be_true
    end

    it "should return false if there was a problem" do
      Configuration.delete(:test).should be_false
    end
  end

  describe "#delete!" do
    it "should raise error if key is nil" do
      expect { Configuration.delete!(nil) }.to raise_error(ArgumentError)
    end

    it "should raise error if key is an empty string" do
      expect { Configuration.write!('') }.to raise_error(ArgumentError)
    end
  end

  describe "caching" do
    it "should cache value on read" do
      Configuration.create(key: 'test', data_string: 'Test string')
      Configuration[:test]
      Rails.cache.read(configurations: 'test').should eq('Test string')
    end

    it "should update cache value on write" do
      Configuration.create(key: 'test', data_string: 'Test string')
      Configuration[:test]
      Configuration[:test] = 'Test string 2'
      Rails.cache.read(configurations: 'test').should eq('Test string 2')
    end

    it "should remove cache on delete" do
      Configuration.create(key: 'test', data_string: 'Test string')
      Configuration[:test]
      Configuration.delete(:test)
      Rails.cache.read(configurations: 'test').should be_nil
    end
  end
end