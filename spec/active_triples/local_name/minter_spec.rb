require 'spec_helper'

describe ActiveTriples::LocalName::Minter do

  describe "#generate_local_name" do
    before (:all) do
      @timeHashMinter_lambda = lambda do |digit_count|
        rnd_id = 0
        rnd_id = Time.now.hash until rnd_id != 0
        rnd_id *= -1 if rnd_id < 0
        rnd_id /= 10 until rnd_id < (10**digit_count)
        "lambda_#{rnd_id}"
      end

      @timeHashMinter_proc = proc do |digit_count|
        rnd_id = 0
        rnd_id = Time.now.hash until rnd_id != 0
        rnd_id *= -1 if rnd_id < 0
        rnd_id /= 10 until rnd_id < (10**digit_count)
        "proc_#{rnd_id}"
      end

      @timeHashMinter2_proc = proc do |digit_count,prefix|
        rnd_id = 0
        rnd_id = Time.now.hash until rnd_id != 0
        rnd_id *= -1 if rnd_id < 0
        rnd_id /= 10 until rnd_id < (10**digit_count)
        "#{prefix}_#{rnd_id}"
      end

      # See also timeHashMinter_method defined in DummyResourceWithBaseURI class below.
    end

    subject {DummyResourceWithBaseURI.new('1')}

    before do
      class DummyResource < ActiveTriples::Resource
        configure :type => RDF::URI('http://example.org/SomeClass')
        property :title, :predicate => RDF::DC.title
      end
      class DummyResourceWithBaseURI < ActiveTriples::Resource
        configure :base_uri => "http://example.org",
                  :type => RDF::URI("http://example.org/SomeClass"),
                  :repository => :default

        def self.timeHashMinter_method( *args )
          digit_count = args.size > 0 ? args[0] : 10
          rnd_id = 0
          rnd_id = Time.now.hash until rnd_id != 0
          rnd_id *= -1 if rnd_id < 0
          rnd_id /= 10 until rnd_id < (10**digit_count)
          "method_#{rnd_id}"
        end

        def self.timeHashMinter2_method( *args )
          digit_count = args && args.size > 0 ? args[0] : 10
          prefix =  args && args.size > 1 ? args[1] : ""
          rnd_id = 0
          rnd_id = Time.now.hash until rnd_id != 0
          rnd_id *= -1 if rnd_id < 0
          rnd_id /= 10 until rnd_id < (10**digit_count)
          "#{prefix}_#{rnd_id}"
        end

        def self.timeHashMinter3_method( *args )
          digit_count = (args && args.size > 0 && args[0]) ? args[0][:digit_count] : 10
          prefix =  args && args.size > 0 && args[0] ? args[0][:prefix] : ""
          rnd_id = 0
          rnd_id = Time.now.hash until rnd_id != 0
          rnd_id *= -1 if rnd_id < 0
          rnd_id /= 10 until rnd_id < (10**digit_count)
          localname = "#{prefix}_#{rnd_id}"
          localname
        end
      end
      ActiveTriples::Repositories.add_repository :default, RDF::Repository.new
    end
    after do
      Object.send(:remove_const, "DummyResourceWithBaseURI") if Object
      Object.send(:remove_const, "DummyResource") if Object
      ActiveTriples::Repositories.clear_repositories!
    end

    context "when one or more arguments are invalid" do
#      def self.generate_local_name(for_class, max_tries=10, *minter_args, &minter_block)

      context "and all arguments are missing" do
        it "should raise error" do
          # NOTE: ruby < 2 puts out (0 for 1); ruby >= 2 puts out (0 for 1+)
          expect{ ActiveTriples::LocalName::Minter.generate_local_name() }.
              to raise_error(ArgumentError, /wrong number of arguments \(0 for 1\+?\)/)
        end
      end

      context "and max_tries is negative" do
        it "should raise error" do
          expect{ ActiveTriples::LocalName::Minter.generate_local_name(DummyResource,-1) }.
              to raise_error(ArgumentError, 'Argument max_tries must be >= 1 if passed in')
        end
      end

      context "and class doesn't inherit from ActiveTriples::Resource" do
        before do
          class DummyNonResource
          end
        end
        after do
          Object.send(:remove_const, "DummyNonResource") if Object
        end

        it "should raise error" do
          expect{ ActiveTriples::LocalName::Minter.generate_local_name(DummyNonResource) }.
              to raise_error(ArgumentError, 'Argument for_class must inherit from ActiveTriples::Resource')
        end
      end


      context "and class doesn't have base_uri defined" do
        it "should raise error" do
          expect{ ActiveTriples::LocalName::Minter.generate_local_name(DummyResource) }.
              to raise_error(RuntimeError, 'Requires base_uri to be defined in for_class.')
        end
      end

      ## TODO: Can't see how to test this.  The test complains if I pass anything other than a Proc instead of complaining that the passing in thing isn't callable.
      # context "block isn't callable" do
      #   it "should raise error" do
      #     x = "foo"
      #     expect{ ActiveTriples::LocalName::Minter.generate_local_name(DummyResourceWithBaseURI,10,{:prefix => 'a'},&x) }.
      #         to raise_error(ArgumentError, 'Invalid minter_block.')
      #   end
      # end
    end

    context "when all IDs available" do
      context "and no minter function is passed in" do
        it "should generate an ID using default minter function" do
          id = ActiveTriples::LocalName::Minter.generate_local_name(DummyResourceWithBaseURI)
          expect(id).to be_kind_of String
          expect(id.length).to eq 36
          expect(id).to match /[a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{12}/
        end
      end

      context "and minter function is passed as ad-hoc proc" do
        it "should generate an ID with passed in minter function block" do
          id = ActiveTriples::LocalName::Minter.generate_local_name(DummyResourceWithBaseURI,10,1) do |digit_count|
            rnd_id = 0
            rnd_id = Time.now.hash until rnd_id != 0
            rnd_id *= -1 if rnd_id < 0
            rnd_id /= 10 until rnd_id < (10**digit_count)
            rnd_id
          end
          expect(id).to be_between(1,9)
        end
      end

      context "and minter function is pre-defined proc that takes 1 parameter" do
        context "and minter function is passed as proc in block with hardcoded parameter" do
          it "should generate an ID with passed in proc in block" do
            id = ActiveTriples::LocalName::Minter.generate_local_name(DummyResourceWithBaseURI) {
              @timeHashMinter_proc.call(1) }
            expect(id[0..4]).to eq "proc_"
            expect(id[5..id.length].to_i).to be_between(1,9)
          end
        end

        context "and minter function is passed as proc in block with parameter passed in minterargs" do
          it "should generate an ID with passed in proc in block" do
            id = ActiveTriples::LocalName::Minter.generate_local_name(DummyResourceWithBaseURI,10,1) {
              |digit_count| @timeHashMinter_proc.call(digit_count) }
            expect(id[0..4]).to eq "proc_"
            expect(id[5..id.length].to_i).to be_between(1,9)
          end
        end

        context "and minter function is passed address to proc with parameter passed in minterargs" do
          it "should generate an ID with passed in proc" do
            id = ActiveTriples::LocalName::Minter.generate_local_name(DummyResourceWithBaseURI,10,1,
                                                                      &@timeHashMinter_proc)
            expect(id[0..4]).to eq "proc_"
            expect(id[5..id.length].to_i).to be_between(1,9)
          end
        end
      end

      context "and minter function is pre-defined proc that takes 2 parameter" do
        context "and minter function is passed as proc in block with hardcoded parameter" do
          it "should generate an ID with passed in proc in block" do
            id = ActiveTriples::LocalName::Minter.generate_local_name(DummyResourceWithBaseURI) {
              @timeHashMinter2_proc.call(1,'foo') }
            expect(id[0..3]).to eq "foo_"
            expect(id[4..id.length].to_i).to be_between(1,9)
          end
        end

        context "and minter function is passed as proc in block with parameter passed in minterargs" do
          it "should generate an ID with passed in proc in block" do
            id = ActiveTriples::LocalName::Minter.generate_local_name(DummyResourceWithBaseURI,10,1,'foo') {
                |digit_count,prefix| @timeHashMinter2_proc.call(digit_count,prefix) }
            expect(id[0..3]).to eq "foo_"
            expect(id[4..id.length].to_i).to be_between(1,9)
          end
        end

        context "and minter function is passed address to proc with parameters passed in minterargs" do
          it "should generate an ID with passed in proc" do
            id = ActiveTriples::LocalName::Minter.generate_local_name(DummyResourceWithBaseURI,10,1,"foo",
                                                                      &@timeHashMinter2_proc)
            expect(id[0..3]).to eq "foo_"
            expect(id[4..id.length].to_i).to be_between(1,9)
          end
        end
      end


      context "and minter function is method that takes 1 parameter" do
        context "and parameter is hardcoded in block" do
          it "should generate an ID with passed in method" do
            id = ActiveTriples::LocalName::Minter.generate_local_name(DummyResourceWithBaseURI) {
              DummyResourceWithBaseURI.timeHashMinter_method (1) }
            expect(id[0..6]).to eq "method_"
            expect(id[7..id.length].to_i).to be_between(1,9)
          end
        end

        context "and parameter is passed as minterargs" do
          it "should generate an ID with passed in method" do
            id = ActiveTriples::LocalName::Minter.generate_local_name(DummyResourceWithBaseURI,10,1) {
                |digit_count| DummyResourceWithBaseURI.timeHashMinter_method(digit_count) }
            expect(id[0..6]).to eq "method_"
            expect(id[7..id.length].to_i).to be_between(1,9)
          end
        end
      end


      context "and minter function is method that takes 2 parameters" do
        context "and parameters are hardcoded in block" do
          it "should generate an ID with passed in method" do
            id = ActiveTriples::LocalName::Minter.generate_local_name(DummyResourceWithBaseURI) {
              DummyResourceWithBaseURI.timeHashMinter2_method(1,"foo") }
            expect(id[0..3]).to eq "foo_"
            expect(id[4..id.length].to_i).to be_between(1,9)
          end
        end

        context "and parameters are passed as minterargs" do
          it "should generate an ID with passed in method" do
            id = ActiveTriples::LocalName::Minter.generate_local_name(DummyResourceWithBaseURI,10,1,"foo") {
                |digit_count,prefix| DummyResourceWithBaseURI.timeHashMinter2_method(digit_count,prefix) }
            expect(id[0..3]).to eq "foo_"
            expect(id[4..id.length].to_i).to be_between(1,9)
          end
        end
      end


      context "and minter function is method that takes 1 hash parameter" do
        context "and parameter is hardcoded in block" do
          it "should generate an ID with passed in method" do
            id = ActiveTriples::LocalName::Minter.generate_local_name(DummyResourceWithBaseURI) {
              DummyResourceWithBaseURI.timeHashMinter3_method({:digit_count=>1,:prefix=>"foo"}) }
            expect(id[0..3]).to eq "foo_"
            expect(id[4..id.length].to_i).to be_between(1,9)
          end
        end
      end

      context "and parameter is passed as minterargs" do
        it "should generate an ID with passed in method" do
          id = ActiveTriples::LocalName::Minter.generate_local_name(DummyResourceWithBaseURI,10,{:digit_count=>1,:prefix=>"foo"}) {
              |hash_args| DummyResourceWithBaseURI.timeHashMinter3_method(hash_args) }
          expect(id[0..3]).to eq "foo_"
          expect(id[4..id.length].to_i).to be_between(1,9)
        end
      end

      context "and no parameters are passed in" do
        it "should generate an ID with passed in method using defaults when no params passed" do
          id = ActiveTriples::LocalName::Minter.generate_local_name(DummyResourceWithBaseURI,10) {
              |hash_args| DummyResourceWithBaseURI.timeHashMinter3_method(hash_args) }
          expect(id[0]).to eq "_"
          expect(id[1..id.length].to_i).to be_between(1000000000,9999999999)
        end
      end

      context "but block defines method with no parameters" do
        it "should generate an ID with passed in method using defaults when no params passed" do
          id = ActiveTriples::LocalName::Minter.generate_local_name(DummyResourceWithBaseURI,10) {
              DummyResourceWithBaseURI.timeHashMinter3_method }
          expect(id[0]).to eq "_"
          expect(id[1..id.length].to_i).to be_between(1000000000,9999999999)
        end
      end
    end
    context "when some IDs available" do
      before do
        DummyResourceWithBaseURI.new('proc_3').persist!
        DummyResourceWithBaseURI.new('proc_4').persist!
        DummyResourceWithBaseURI.new('proc_8').persist!
      end
      after do
        DummyResourceWithBaseURI.new('proc_3').destroy!
        DummyResourceWithBaseURI.new('proc_4').destroy!
        DummyResourceWithBaseURI.new('proc_8').destroy!
      end

      it "should generate an ID not already in use" do
        id = ActiveTriples::LocalName::Minter.generate_local_name(DummyResourceWithBaseURI) { @timeHashMinter_proc.call(1) }
        expect(id[0..4]).to eq "proc_"
        expect(id[5..id.length].to_i).to be_between(1,9)
        expect(id).not_to eq 'proc_3'
        expect(id).not_to eq 'proc_4'
        expect(id).not_to eq 'proc_8'
      end
    end

    context "when no IDs available" do
      before do
        1.upto(9) { |id| DummyResourceWithBaseURI.new("proc_#{id}").persist! }
      end
      after do
        1.upto(9) { |id| DummyResourceWithBaseURI.new("proc_#{id}").destroy! }
      end

      it "should raise an Exception" do
        expect{ ActiveTriples::LocalName::Minter.generate_local_name(DummyResourceWithBaseURI) { @timeHashMinter_proc.call(1) } }.
            to raise_error(RuntimeError, "Available ID not found.  Exceeded maximum tries.")
      end
    end

    context "when passing prefix to default minter function" do
      context "and prefix is string" do
        it "should generate a prefixed ID" do
          id = ActiveTriples::LocalName::Minter.generate_local_name(DummyResourceWithBaseURI,10,{:prefix=>"s"})
          expect(id).to be_kind_of String
          expect(id.length).to eq 37
          expect(id).to match /s[a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{12}/
        end
      end

      context "and prefix is integer" do
        it "should generate ID ignoring prefix" do
          id = ActiveTriples::LocalName::Minter.generate_local_name(DummyResourceWithBaseURI,10,1)
          expect(id).to be_kind_of String
          expect(id.length).to eq 36
          expect(id).to match /[a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{12}/
        end
      end

      context "and prefix is float" do
        it "should generate ID ignoring prefix" do
          id = ActiveTriples::LocalName::Minter.generate_local_name(DummyResourceWithBaseURI,10,{:prefix=>1.5})
          expect(id).to be_kind_of String
          expect(id.length).to eq 36
          expect(id).to match /[a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{12}/
        end
      end

      context "and prefix is hash" do
        it "should generate ID ignoring prefix" do
          id = ActiveTriples::LocalName::Minter.generate_local_name(DummyResourceWithBaseURI,10,{:prefix=>{"a"=>"b"}})
          expect(id).to be_kind_of String
          expect(id.length).to eq 36
          expect(id).to match /[a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{12}/
        end
      end

      context "and prefix is array" do
        it "should generate ID ignoring prefix" do
          id = ActiveTriples::LocalName::Minter.generate_local_name(DummyResourceWithBaseURI,10,{:prefix=>[1,2,3]})
          expect(id).to be_kind_of String
          expect(id.length).to eq 36
          expect(id).to match /[a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{12}/
        end
      end
    end

  end

  describe "default_minter" do
    context "when options are empty" do
      it "creates a uuid" do
        id = ActiveTriples::LocalName::Minter.default_minter
        expect(id).to be_kind_of String
        expect(id.length).to eq 36
        expect(id).to match /[a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{12}/
      end
    end

    context "when options is passed a prefix" do
      context "and prefix is string" do
        it "should generate a prefixed ID" do
          id = ActiveTriples::LocalName::Minter.default_minter({:prefix=>"s"})
          expect(id).to be_kind_of String
          expect(id.length).to eq 37
          expect(id).to match /s[a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{12}/
        end
      end

      context "and prefix is integer" do
        it "should generate ID ignoring prefix" do
          id = ActiveTriples::LocalName::Minter.default_minter({:prefix=>1})
          expect(id).to be_kind_of String
          expect(id.length).to eq 36
          expect(id).to match /[a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{12}/
        end
      end

      context "and prefix is float" do
        it "should generate ID ignoring prefix" do
          id = ActiveTriples::LocalName::Minter.default_minter({:prefix=>1.5})
          expect(id).to be_kind_of String
          expect(id.length).to eq 36
          expect(id).to match /[a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{12}/
        end
      end

      context "and prefix is hash" do
        it "should generate ID ignoring prefix" do
          id = ActiveTriples::LocalName::Minter.default_minter({:prefix=>{"a"=>"b"}})
          expect(id).to be_kind_of String
          expect(id.length).to eq 36
          expect(id).to match /[a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{12}/
        end
      end

      context "and prefix is array" do
        it "should generate ID ignoring prefix" do
          id = ActiveTriples::LocalName::Minter.default_minter({:prefix=>[1,2,3]})
          expect(id).to be_kind_of String
          expect(id.length).to eq 36
          expect(id).to match /[a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{12}/
        end
      end
    end
  end
end
