import SwiftUI

struct PrayerTimesView: View {
    @State private var selectedPrayer: String = "الفجر"
    @State private var backgroundType: BackgroundType = .night
    
    enum BackgroundType {
        case night      // الفجر والعشاء
        case sunrise    // الظهر والعصر
        case sunset     // المغرب
    }
    
    let prayers = [
        ("الفجر", "4:57 ص", BackgroundType.night),
        ("الظهر", "11:42 م", BackgroundType.sunrise),
        ("العصر", "2:43 م", BackgroundType.sunrise),
        ("المغرب", "5:04 م", BackgroundType.sunset),
        ("العشاء", "6:34 م", BackgroundType.night)
    ]
    
    var body: some View {
        ZStack {
            // الخلفية المتدرجة
            backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // أيقونات الإعدادات والبوصلة
                HStack {
                    Button(action: {}) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white.opacity(0.9))
                            .frame(width: 50, height: 50)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Circle())
                    }
                    
                    Button(action: {}) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white.opacity(0.9))
                            .frame(width: 50, height: 50)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 50)
                
                Spacer()
                
                // منطقة الشمس/القمر
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white.opacity(0.15))
                        .frame(height: 200)
                    
                    celestialBody
                }
                .padding(.horizontal, 24)
                
                
                Text("الآن وقت صلاة \(selectedPrayer)")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.top, 30)
                    .padding(.bottom, 20)
                
                // قائمة أوقات الصلاة
                VStack(spacing: 12) {
                    ForEach(prayers, id: \.0) { prayer in
                        PrayerTimeRow(
                            name: prayer.0,
                            time: prayer.1,
                            isSelected: selectedPrayer == prayer.0
                        )
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                selectedPrayer = prayer.0
                                backgroundType = prayer.2
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
        }
    }
    
    // الخلفية المتدرجة حسب الوقت
    var backgroundGradient: LinearGradient {
        switch backgroundType {
        case .night:
            return LinearGradient(
                colors: [
                    Color(red: 0.15, green: 0.15, blue: 0.25),
                    Color(red: 0.1, green: 0.1, blue: 0.2)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        case .sunrise:
            return LinearGradient(
                colors: [
                    Color(red: 0.4, green: 0.6, blue: 0.95),
                    Color(red: 0.6, green: 0.75, blue: 0.95)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        case .sunset:
            return LinearGradient(
                colors: [
                    Color(red: 0.65, green: 0.45, blue: 0.65),
                    Color(red: 0.85, green: 0.6, blue: 0.5)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
    
    // الشمس أو القمر
    @ViewBuilder
    var celestialBody: some View {
        if backgroundType == .night {
            // القمر
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.9))
                    .frame(width: 120, height: 120)
                    .shadow(color: .white.opacity(0.3), radius: 30)
                
                // فوهات القمر
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 25, height: 25)
                    .offset(x: -15, y: -10)
                
                Circle()
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: 30, height: 30)
                    .offset(x: 20, y: 15)
                
                Circle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 20, height: 20)
                    .offset(x: 10, y: -20)
            }
        } else {
            // الشمس
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.yellow.opacity(0.9),
                                Color.orange.opacity(0.7)
                            ],
                            center: .center,
                            startRadius: 20,
                            endRadius: 80
                        )
                    )
                    .frame(width: 130, height: 130)
                    .shadow(color: .yellow.opacity(0.4), radius: 30)
                
                // سحب صغيرة
                if backgroundType == .sunrise {
                    Capsule()
                        .fill(Color.white.opacity(0.6))
                        .frame(width: 60, height: 20)
                        .offset(x: -70, y: 30)
                    
                    Capsule()
                        .fill(Color.white.opacity(0.5))
                        .frame(width: 50, height: 18)
                        .offset(x: 75, y: 20)
                }
            }
        }
    }
}

struct PrayerTimeRow: View {
    let name: String
    let time: String
    let isSelected: Bool
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 20))
                
                Text(name)
                    .font(.system(size: 18, weight: .medium))
            }
            
            Spacer()
            
            Text(time)
                .font(.system(size: 16))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(isSelected ? 0.25 : 0.15))
        )
    }
}


struct PrayerTimesView_Previews: PreviewProvider {
    static var previews: some View {
        PrayerTimesView()
    }
}
