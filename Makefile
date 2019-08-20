destination = "platform=macOS"
projectName = "puma.xcodeproj"
packageName = "Puma-Package"
derivedDataPath = "./xctest"

project:
	swift package generate-xcodeproj
	
clear:
	rm -rf $(projectName)
	
build_scope:
	xcodebuild -scheme $(packageName) -destination $(destination) | xcpretty

build: project build_scope clear
	
test_scope:
	set -o pipefail && xcodebuild -scheme $(packageName) -enableCodeCoverage YES -destination $(destination) test | xcpretty

build_for_testing_ci:
	set -o pipefail && xcodebuild -scheme $(packageName) -enableCodeCoverage YES -derivedDataPath $(derivedDataPath) -destination $(destination) build-for-testing | xcpretty

test_scope_ci:
	set -o pipefail && xcodebuild -scheme $(packageName) -enableCodeCoverage YES -derivedDataPath $(derivedDataPath) -destination $(destination) test-without-building | xcpretty -r junit

test: project test_scope clear

build_unit_tests_ci: project build_for_testing_ci clear

test_ci: project test_scope_ci clear

lint_scope:
	swiftlint
	
lint_autocorrect_scope:
	swiftlint autocorrect

lint: project lint_scope clear

fixlint: project lint_autocorrect_scope clear

jazzy_scope:
	jazzy -c

jazzy: project jazzy_scope clear