import SwiftUI

struct ContentView: View {
    @State private var focus = ""
    @State private var navigate = false
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.pink.opacity(0.15)
                    .ignoresSafeArea()
                
                VStack(spacing: 35) {
                    header
                    prompt
                    inputField
                    actionButton
                    navigation
                }
                .padding()
            }
        }
        .frame(minWidth: 450, minHeight: 550)
    }
    
    private var header: some View {
        Text("🎯 Cammit")
            .font(.system(size: 52, weight: .black))
            .foregroundColor(.pink)
    }
    
    private var prompt: some View {
        Text("How long do you want to focus?")
            .font(.title)
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
    }
    
    private var inputField: some View {
        TextField("Enter focus time (minutes)", text: $focus)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(width: 300)
            .multilineTextAlignment(.center)
            .font(.system(size: 18, weight: .medium))
    }
    
    private var actionButton: some View {
        Button(action: validateAndNavigate) {
            Text("Start Session")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
                .background(.clear)
                
        }
        .frame(width: 220, height: 50)
        .background(Color.pink)
        .cornerRadius(15)
        .buttonStyle(PlainButtonStyle())
        .alert("❌ Invalid input. Please enter a number.", isPresented: $showAlert) {}
    }
    
    private var navigation: some View {
        NavigationLink(
            destination: SessionView(focusMinutes: Int(focus) ?? 0, breakMinutes: 5),
            isActive: $navigate
        ) {
            EmptyView()
        }
        .hidden()
    }
    
    private func validateAndNavigate() {
        if Int(focus) != nil {
            navigate = true
        } else {
            showAlert = true
        }
    }
}

#Preview {
    ContentView()
}
