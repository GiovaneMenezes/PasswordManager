# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

inhibit_all_warnings!

target 'PasswordManager' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!

    # Pods for PasswordManager
    pod 'RxSwift',    '~> 4.0'
    pod 'RxCocoa',    '~> 4.0'
    pod 'NSObject+Rx'
    pod 'Action'
    pod 'Moya/RxSwift', '~> 11.0'
    pod 'Validator'
    pod 'Moya/RxSwift', '~> 11.0'
    pod 'RxAnimated'

    target 'PasswordManagerTests' do
        inherit! :search_paths
        # Pods for testing
        pod 'RxBlocking', '~> 4.0'
        pod 'RxTest',     '~> 4.0'
        pod 'Quick'
        pod 'Nimble'
        pod 'RxNimble'
    end

    target 'PasswordManagerUITests' do
        inherit! :search_paths
        # Pods for testing
    end

    post_install do |installer|
        installer.pods_project.targets.each do |target|
            if target.name == 'RxSwift'
                target.build_configurations.each do |config|
                    if config.name == 'Debug'
                        config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['$(inherited)', '-D', 'TRACE_RESOURCES']
                    end
                end
            end
        end
    end

end

target 'TestHost' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!

    # Pods for TestHost

end
