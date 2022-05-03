import XCTest

extension XCUIApplication {
  func tapKey(_ key: String) {
    // NOTE: need to skip keyboard onboarding, https://developer.apple.com/forums/thread/650826
    let keyButton = self.keys[key]
    if !keyButton.isHittable {
      // NOTE: sometimes it might need time to come into existence
      _ = keyButton.waitForExistence(timeout: 1)
      // NOTE: if still not hittable, there should be an onboarding screen
      if !keyButton.isHittable {
        self.buttons["Continue"].tap()
      }
    }
    keyButton.tap()
  }
}

class SoftTest: XCTestCase {
  override func setUpWithError() throws {
    continueAfterFailure = false
  }
  
  override func tearDownWithError() throws {}
  
  func testSoftwareKeyboard() throws {
    let app = XCUIApplication()
    app.launch()
    
    let textField = app.textFields.element(boundBy: 0)
    textField.tap()
    app.tapKey("A")
    RunLoop.current.run(until: .now + 0.5)
    app.tapKey("b")
    RunLoop.current.run(until: .now + 0.5)
    app.tapKey("c")
    
    XCTAssertEqual(textField.value as? String, "Abc")
  }
}
