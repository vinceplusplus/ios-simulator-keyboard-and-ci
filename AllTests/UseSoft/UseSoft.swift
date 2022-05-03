import XCTest

// NOTE: doesn't mean to be a meaningful test case but a way to let the next test to start off with software keyboard enabled
class UseSoft: XCTestCase {
  override func setUpWithError() throws {
    continueAfterFailure = false
  }
  
  override func tearDownWithError() throws {}
  
  func testToUseSoftwareKeyboard() throws {
    let app = XCUIApplication()
    app.launch()
    
    let textField = app.textFields.element(boundBy: 0)
    textField.tap()
    
    showSoftwareKeyboardByAutomation(app, shows: true)
    let key = app.keys["A"]
    XCTAssert(key.exists && key.isHittable)
    textField.typeText("A")
    XCTAssertEqual(textField.value as? String, "A")
  }
}
