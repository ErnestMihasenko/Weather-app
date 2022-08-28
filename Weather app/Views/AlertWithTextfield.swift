import SwiftUI

struct TextFieldAlert<Presenting>: View where Presenting: View {
    
    @Binding var isShowing: Bool
    @Binding var text: String
    let presenting: Presenting
    let title: String
    let textfieldTitle: String
    let action: () -> Void
    
    var body: some View {
        GeometryReader { (deviceSize: GeometryProxy) in
            ZStack {
                self.presenting
                    .disabled(isShowing)
                VStack {
                    Text(self.title)
                    TextField(self.textfieldTitle, text: self.$text)
                    Divider()
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                self.isShowing.toggle()
                            }
                        }) {
                            Text("Dismiss")
                        }
                        Spacer()
                        Spacer()
                        Button(action: {
                            action()
                            withAnimation {
                                self.isShowing.toggle()
                            }
                        }) {
                            Text("Ok")
                        }
                        Spacer()
                    }
                }
                .padding()
                .background(Color.white)
                .frame(
                    width: deviceSize.size.width*0.7,
                    height: deviceSize.size.height*0.7
                )
                .shadow(radius: 1)
                .opacity(self.isShowing ? 1 : 0)
            }
        }
    }
    
}

extension View {
    
    func textFieldAlert(isShowing: Binding<Bool>,
                        text: Binding<String>,
                        title: String,
                        textfieldTitle: String,
                        action: @escaping () -> Void) -> some View {
        TextFieldAlert(
            isShowing: isShowing,
            text: text,
            presenting: self,
            title: title,
            textfieldTitle: textfieldTitle,
            action: action
        )
    }
}
