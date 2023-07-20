require_relative 'lib/flutterwave_sdk/version'

Gem::Specification.new do |spec|
  spec.name          = "flutterwave_sdk"
  spec.version       = FlutterwaveSdk::VERSION
  spec.authors       = ["Flutterwave Developers"]
  spec.email         = ["developers@flutterwavego.com"]

spec.date        = '2020-05-10'
  spec.summary       = %q{Official Ruby Gem For Flutterwave APIs.}
  spec.description   = %q{This is the official Ruby Gem For Flutterwave Payments which includes Card, Account, Transfer, Subaccount, Subscription, Mpesa, Ghana Mobile Money, Ussd, Payment Plans, and Transfer payment methods.}
  spec.homepage      = "https://github.com/Flutterwave/Flutterwave-Ruby-v3."
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.1.4"
  #add dotenv
  spec.add_development_dependency "dotenv", "~> 2.8.1"

  # Dependencies
  spec.required_ruby_version = ">= 2.5.3"
  spec.add_runtime_dependency 'httparty', '~> 0.16.3'
end
