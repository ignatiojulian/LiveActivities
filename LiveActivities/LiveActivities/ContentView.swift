//
//  ContentView.swift
//  LiveActivities
//
//  Created by Ignatio Julian on 08/10/22.
//

import SwiftUI
import ActivityKit

struct ContentView: View {
    @State var showDeepLinkAction: Bool = false
    @State var driver = ""
    
    var body: some View {
        ZStack {
            backgroundImage
            actionButton
        }
        .onTapGesture {
            showAllDeliveries()
        }
        .navigationTitle("Astro")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Text("Groceries in 15 Mins").bold()
                    .onTapGesture {
                        startPizzaAd()
                    }
            }
        }
        .preferredColorScheme(.dark)
        .onOpenURL { url in
            driver = url.absoluteString.replacingOccurrences(of: "astro://", with: "")
            showDeepLinkAction = true
        }
        .confirmationDialog("Call Driver", isPresented: $showDeepLinkAction) {
            Link("(+62)85171162398", destination: URL(string: "tel:+6285171162398")!)
            Button("Cancel", role: .cancel) {
                showDeepLinkAction = false
            }
        } message: {
            Text("Are you sure to call \(driver)?")
        }
    }
    
    var backgroundImage: some View {
        Image("background")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
    }
    
    var actionButton: some View {
        VStack(spacing: 0) {
            Spacer()
            
            HStack(spacing:0) {
                Button(action: { startDeliveryPizza() }) {
                    HStack {
                        Spacer()
                        Text("Start Ordering 👨🏻‍🍳").font(.headline)
                        Spacer()
                    }.frame(height: 60)
                }.tint(.blue)
                Button(action: { updateDeliveryPizza() }) {
                    HStack {
                        Spacer()
                        Text("Update Order 🫠").font(.headline)
                        Spacer()
                    }.frame(height: 60)
                }.tint(.purple)
            }.frame(maxWidth: UIScreen.main.bounds.size.width)
            
            Button(action: { stopDeliveryPizza() }) {
                HStack {
                    Spacer()
                    Text("Cancel Order 😞").font(.headline)
                    Spacer()
                }.frame(height: 60)
                .padding(.bottom)
            }.tint(.pink)
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.roundedRectangle(radius: 0))
        .ignoresSafeArea(edges: .bottom)
    }
    
    // MARK: - Functions
    func startDeliveryPizza() {
        let astroDeliveryAttributes = AstroDeliveryAttributes(numberOfQuantity: 1, totalAmount:"$99")

        let initialContentState = AstroDeliveryAttributes.DeliveryStatus(driverName: "TIM 👨🏻‍🍳", estimatedDeliveryTime: Date()...Date().addingTimeInterval(15 * 60))
                                                  
        do {
            let deliveryActivity = try Activity<AstroDeliveryAttributes>.request(
                attributes: astroDeliveryAttributes,
                contentState: initialContentState,
                pushType: nil)
            print("Requested a pizza delivery Live Activity \(deliveryActivity.id)")
        } catch (let error) {
            print("Error requesting pizza delivery Live Activity \(error.localizedDescription)")
        }
    }
    func updateDeliveryPizza() {
        Task {
            let updatedDeliveryStatus = AstroDeliveryAttributes.DeliveryStatus(driverName: "TIM 👨🏻‍🍳", estimatedDeliveryTime: Date()...Date().addingTimeInterval(60 * 60))
            
            for activity in Activity<AstroDeliveryAttributes>.activities{
                await activity.update(using: updatedDeliveryStatus)
            }
        }
    }
    func stopDeliveryPizza() {
        Task {
            for activity in Activity<AstroDeliveryAttributes>.activities{
                await activity.end(dismissalPolicy: .immediate)
            }
        }
    }
    func showAllDeliveries() {
        Task {
            for activity in Activity<AstroDeliveryAttributes>.activities {
                print("Pizza delivery details: \(activity.id) -> \(activity.attributes)")
            }
        }
    }
    
    @MainActor
    func startPizzaAd() {
        // Fetch image from Internet and convert it to jpegData
        let url = URL(string: "https://img.freepik.com/premium-vector/pizza-logo-design_9845-319.jpg?w=2000")!
        let data = try! Data(contentsOf: url)
        let image = UIImage(data: data)!
        let jpegData = image.jpegData(compressionQuality: 1.0)!
        UserDefaults(suiteName: "group.io.startway.iOS16-Live-Activities")?.set(jpegData, forKey: "pizzaLogo")

        let pizzaAdAttributes = AdAttributes(discount: "$100")
        let initialContentState = AdAttributes.AdStatus(adName: "TIM 👨🏻‍🍳 's Pizza Offer", showTime: Date().addingTimeInterval(60 * 60))
        do {
            let deliveryActivity = try Activity<AdAttributes>.request(
                attributes: pizzaAdAttributes,
                contentState: initialContentState,
                pushType: nil)
            print("Requested a pizza ad Live Activity \(deliveryActivity.id)")
        } catch (let error) {
            print("Error requesting pizza ad Live Activity \(error.localizedDescription)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
