require 'turnip/rspec'

module Rutabaga
  module Feature
    def feature(feature_file = find_feature)

      example_group_class = self.class

      # Hack turnip into the rspec only when needed
      example_group_class.send(:include, Turnip::RSpec::Execute)
      example_group_class.send(:include, Turnip::Steps)

      run(feature_file, example_group_class)
    end

    def find_feature
      return get_example.description if File.exists?(get_example.description)

      feature_file = caller(0).find do |call|
        call =~ /_spec.rb:/
      end.gsub(/_spec.rb:.*\Z/, '.feature')
      return feature_file if File.exists?(feature_file)

      raise "Feature file not found. Tried: #{get_example.description} and #{feature_file}"
    end

    private

    # Code copied and modified from jnicklas/turnip v1.3.0
    def run(feature_file, example_group_class)
      Turnip::Builder.build(feature_file).features.each do |feature|
        instance_eval <<-EOS, feature_file, feature.line
          describe = example_group_class.describe feature.name, feature.metadata_hash
          run_feature(describe, feature, feature_file, example_group_class)
        EOS
      end
    end

    def run_feature(describe, feature, filename, example_group_class)
      example_group_class.before do
        feature.backgrounds.map(&:steps).flatten.each do |step|
          run_step(filename, step)
        end
      end

      feature.scenarios.each do |scenario|
        instance_eval <<-EOS, filename, scenario.line
          example_group_class.describe scenario.name, scenario.metadata_hash do 
            it(scenario.steps.map(&:to_s).join(' -> ')) do
              scenario.steps.each do |step|
                run_step(filename, step)
              end
            end
          end
        EOS
      end
    end

    # For compatibility with rspec 2 and rspec 3. RSpec.current_example was added late in
    # the rspec 2 cycle.
    def get_example
      begin
        @example ||= RSpec.current_example
      rescue NameError => e
        @example ||= example
      end
    end
  end
end

::RSpec.configure do |c|
  c.include Rutabaga::Feature
  # Blow away turnip's pattern, and focus just on features directory
  c.pattern.gsub!(",**/*.feature", ",features/**/*.feature")
end
