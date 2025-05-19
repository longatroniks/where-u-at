import SwiftUI
import MapKit

struct LocationInfoView: View {
    var location: Location
    @Binding var isPresented: Bool

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()

                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(location.name)
                                .font(.headline)
                                .foregroundColor(Color.primary)

                            Text(location.description)
                                .font(.subheadline)
                                .foregroundColor(Color.secondary)
                        }
                        .padding(.leading)

                        Spacer()

                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                self.isPresented = false
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .foregroundColor(Color.secondary)
                        }
                        .padding(.trailing)
                    }
                }
                .padding(.vertical)
                .frame(width: geometry.size.width - 40)
                .background(RoundedRectangle(cornerRadius: 15).fill(Color(UIColor.systemBackground)))
                .shadow(radius: 5)
                .padding(.horizontal, 20)
                .padding(.bottom, 90)
            }
            .transition(.asymmetric(insertion: .opacity.combined(with: .scale(scale: 1.1)),
                                    removal: .opacity.combined(with: .scale(scale: 0.9))))
            .animation(.easeInOut(duration: 0.5), value: isPresented)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

