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

class HackySoftHardTest: XCTestCase {
  override func setUpWithError() throws {
    continueAfterFailure = false
  }
  
  override func tearDownWithError() throws {}
  
  func testSoftAndHard() throws {
    let app = XCUIApplication()
    app.launch()
    
    let textField = app.textFields.element(boundBy: 0)
    
    app.buttons["Disable Hardware Keyboard"].tap()
    // NOTE: use of the "Focus" button to avoid the automatic red background marking replacement suggestion
    app.buttons["Focus"].tap()
    RunLoop.current.run(until: .now + 1)
    app.tapKey("A")
    app.tapKey("b")
    app.tapKey("c")
    XCTAssertEqual(textField.value as? String, "Abc")
    
    app.buttons["Blur"].tap()
    RunLoop.current.run(until: .now + 1)
    app.buttons["Enable Hardware Keyboard"].tap()
    RunLoop.current.run(until: .now + 1)
    app.buttons["Focus"].tap()
    RunLoop.current.run(until: .now + 1)
    textField.typeText("def")
    XCTAssertEqual(textField.value as? String, "Abcdef")
    
    app.buttons["Blur"].tap()
    RunLoop.current.run(until: .now + 1)
    app.buttons["Disable Hardware Keyboard"].tap()
    RunLoop.current.run(until: .now + 1)
    app.buttons["Focus"].tap()
    RunLoop.current.run(until: .now + 1)
    app.tapKey("more")
    app.tapKey("1")
    app.tapKey("2")
    app.tapKey("3")
    XCTAssertEqual(textField.value as? String, "Abcdef123")
  }
}
