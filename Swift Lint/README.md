# FIVE iOS Swift Lint Rules

## Overview
SwiftLint is a tool to enforce Swift style and conventions.
 
Main benefits from SwiftLint are:
* It helps new developers to follow our code style guide.
* SwiftLint will show warnings if the code style guide is not followed.
* It will help us to not make the same mistake every time.
* Comments on pull requests will be reduced because build checks will fail usually before anybody looks at PR.
 
You can find more information [here](https://github.com/realm/SwiftLint).

## Code Style
SwiftLint was originally based on [GitHub’s Swift Style Guide](https://github.com/github/swift-style-guide). However, because this style guide is not active anymore we are following a Swift style guide from Ray Wenderlich. His style guide can be found [here](https://github.com/raywenderlich/swift-style-guide) and it is regularly maintained.

## Integration into project
**Basic setup**

To enable SwiftLint in your project you have to:
<ol>
<li>Add the following line to your Podfile: pod 'SwiftLint', '0.39.2'. Check the latest release tag here: https://github.com/realm/SwiftLint/tags.</li>
<li>Include .switlint.yml file to root project directory. This file will be hidden but it is used for SwiftLint configuration. You can create this file from XCode as an empty file or you can find an example here https://github.com/raywenderlich/swift-algorithm-club/blob/master/.swiftlint.yml and just copy it. Make sure to stage it for commit if you have a source control system.</li>
<li>You need to add a SwiftLint run phase:</li>
  
<ol>
<li>In XCode, click on project</li>
<li>Select desired target</li>
<li>Select Build phases</li>
<li>Click on Add button and select New Run Script Phase</li>
<li>In definition, add this: ${PODS_ROOT}/SwiftLint/swiftlint</li>
<li>Run pod install and rebuild the project</li>
</ol>
  
</ol>

**Update SwiftLint to  Ray Wenderlich style guide**

We are overriding default behavior of some SwiftLint rules to follow Ray Wenderlich style guide. If we just want to notify the developer that he is not following a specific rule then a warning is used. If there is some important rule broken, error is used and this will give us build error. We already mentioned an example of .swiftlint.yml file but we updated this file and we can use this as our default .swiftlint.yml structure:

```yaml
function_parameter_count: 8 
identifier_name: 
  min_length: 2 
  max_length: 50 
line_length: 
  warning: 120 
  ignores_comments: true 
type_name: 
  max_length: 50
function_parameter_count: 
  warning: 9 
  error: 12 
large_tuple: 4

```

