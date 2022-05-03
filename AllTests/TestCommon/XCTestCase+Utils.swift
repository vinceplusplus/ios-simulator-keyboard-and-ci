import XCTest

extension XCTestCase {
  func toggleSoftwareKeyboard() {
    let expectation = expectation(description: "Software Keyboard Toggle Request")
    Task {
      do {
        let url = URL(string: "http://localhost:8080/toggle-software-keyboard")!
        let (_, response) = try await URLSession.shared.data(for: .init(url: url))
        if
          let response = response as? HTTPURLResponse,
          (200...299).contains(response.statusCode)
        {
          expectation.fulfill()
        } else {
          XCTFail()
        }
      } catch {
        XCTFail()
      }
    }
    wait(for: [expectation], timeout: 5)
  }
  
  func showSoftwareKeyboardByAutomation(_ app: XCUIApplication, shows: Bool) {
    let key1 = app.keys["A"]
    let key2 = app.keys["a"]
    let key3 = app.keys["b"]
    let key4 = app.keys["1"]
    
    func checkKeyboardPresence() -> Bool {
      (key1.exists && key1.isHittable) ||
      (key2.exists && key2.isHittable) ||
      (key3.exists && key3.isHittable) ||
      (key4.exists && key4.isHittable)
    }
    
    RunLoop.current.run(until: .now + 1)
    
    guard checkKeyboardPresence() != shows else {
      return
    }
    
    // NOTE: we can use the first toggle to dismiss the onboarding/tutorial screen
    toggleSoftwareKeyboard()
    RunLoop.current.run(until: .now + 1)
    if checkKeyboardPresence() != shows {
      toggleSoftwareKeyboard()
    }
    RunLoop.current.run(until: .now + 1)
  }
}
