

import Foundation
import SwiftUI

struct Whitecolor: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.white)
    }
}


   

extension View {
    func whiteColor() -> some View {
        self.modifier(Whitecolor())
    }
}
