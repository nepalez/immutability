# encoding: utf-8

RSpec.configure do |config|
  mod = Module.new do
    # Returns the double with +#frozen?+ and +#freeze+ methods defined
    #
    def frozen_double(*args)
      options  = args.last.instance_of?(Hash) ? args.pop : {}
      name     = args.first
      instance = double name, options.merge(frozen?: true)
      allow(instance).to receive(:freeze).and_return(instance)

      instance
    end
  end

  config.include mod
end
