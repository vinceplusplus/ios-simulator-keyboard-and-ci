import SwiftUI

#if targetEnvironment(simulator)
class HardwareKeyboardDisablingHack {
  static let shared = HardwareKeyboardDisablingHack()

  private let setter = NSSelectorFromString("setHardwareLayout:")
  private let getter = NSSelectorFromString("hardwareLayout")
  private(set) var hardwareKeyboardIsDisabled = false
  private var originalState = [UITextInputMode: AnyObject]()

  func disableHardwareKeyboard() {
    if !hardwareKeyboardIsDisabled {
      UITextInputMode.activeInputModes.forEach {
        if
          $0.responds(to: getter) && $0.responds(to: setter),
          let value = $0.perform(getter)
        {
          originalState[$0] = value.takeUnretainedValue()
          $0.perform(setter, with: nil)
        }
      }
      
      hardwareKeyboardIsDisabled = true
    }
  }
  
  func enableHardwareKeyboard() {
    if hardwareKeyboardIsDisabled {
      originalState.forEach {
        $0.key.perform(setter, with: $0.value)
      }
      
      hardwareKeyboardIsDisabled = false
    }
  }
}
#endif

struct ContentView: View {
  @State var text = ""
  @FocusState var isFocused: Bool
  
  var body: some View {
    VStack {
      TextField("", text: $text)
        .focused($isFocused)
        .disableAutocorrection(true)
        .border(Color.gray)
      Button {
        isFocused = true
      } label: {
        Text("Focus")
      }
      Button {
        isFocused = false
      } label: {
        Text("Blur")
      }
      Button {
        HardwareKeyboardDisablingHack.shared.disableHardwareKeyboard()
      } label: {
        Text("Disable Hardware Keyboard")
      }
      Button {
        HardwareKeyboardDisablingHack.shared.enableHardwareKeyboard()
      } label: {
        Text("Enable Hardware Keyboard")
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
