module EventedSpec
  # If you include EventedSpec::AMQPSpec module into your example group, each example of this group
  # will run inside AMQP.start loop without the need to explicitly call 'amqp'. In order
  # to provide options to AMQP loop, default_options class method is defined. Remember,
  # when using EventedSpec::Specs, you'll have a single set of AMQP.start options for all your
  # examples.
  #
  module AMQPSpec
    def self.included(example_group)
      example_group.send(:include, SpecHelper)
      example_group.extend(ClassMethods)
    end

    # @private
    module ClassMethods
      def it(*args, &block)
        if block
          new_block = Proc.new {|example_group_instance=self| (example_group_instance || self).instance_eval { amqp(&block) } }
          super(*args, &new_block)
        else
          # pending example
          super
        end
      end # it
    end # ClassMethods
  end # AMQPSpec
end # module EventedSpec
