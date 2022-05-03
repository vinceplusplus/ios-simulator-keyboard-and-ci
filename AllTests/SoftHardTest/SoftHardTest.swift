import XCTest

class SoftHardTest: XCTestCase {
  override func setUpWithError() throws {
    continueAfterFailure = false
  }
  
  override func tearDownWithError() throws {}
  
  func testSoftAndHardWithoutHack() throws {
    let app = XCUIApplication()
    app.launch()
    
    let textField = app.textFields.element(boundBy: 0)
    
    // NOTE: use of the "Focus" button to avoid the automatic red background marking replacement suggestion
    app.buttons["Focus"].tap()
    RunLoop.current.run(until: .now + 1)
    showSoftwareKeyboardByAutomation(app, shows: true)
    app.keys["A"].tap()
    RunLoop.current.run(until: .now + 0.5)
    app.keys["b"].tap()
    RunLoop.current.run(until: .now + 0.5)
    app.keys["c"].tap()
    XCTAssertEqual(textField.value as? String, "Abc")
    
    app.buttons["Blur"].tap()
    RunLoop.current.run(until: .now + 1)
    app.buttons["Focus"].tap()
    RunLoop.current.run(until: .now + 1)
    showSoftwareKeyboardByAutomation(app, shows: false)
    textField.typeText("def")
    XCTAssertEqual(textField.value as? String, "Abcdef")
    
    app.buttons["Blur"].tap()
    RunLoop.current.run(until: .now + 1)
    app.buttons["Focus"].tap()
    RunLoop.current.run(until: .now + 1)
    showSoftwareKeyboardByAutomation(app, shows: true)
    app.keys["more"].tap()
    RunLoop.current.run(until: .now + 0.5)
    app.keys["1"].tap()
    RunLoop.current.run(until: .now + 0.5)
    app.keys["2"].tap()
    RunLoop.current.run(until: .now + 0.5)
    app.keys["3"].tap()
    XCTAssertEqual(textField.value as? String, "Abcdef123")
  }
}
