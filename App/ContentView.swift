import SwiftUI

struct ContentView: View {
    @State private var targetApp: String = "com.example.targetapp"
    @State private var swipeCount: Int = 100
    @State private var likeProbability: Double = 0.3
    @State private var watchTime: String = "00:00"
    @State private var aiAction: String = "无"
    @State private var deepSeekAPIKey: String = "sk-your-key"

    private var deepSeek: DeepSeekClient {
        DeepSeekClient(apiKey: deepSeekAPIKey)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("目标配置")) {
                    TextField("目标 Bundle ID", text: $targetApp)
                    Stepper("滑动次数: \(swipeCount)", value: $swipeCount, in: 1...1000)
                    VStack(alignment: .leading) {
                        Text("点赞概率: \(Int(likeProbability * 100))%")
                        Slider(value: $likeProbability, in: 0...1, step: 0.05)
                    }
                }
                Section(header: Text("屏幕时长提取")) {
                    HStack {
                        Text("当前观看时长:")
                        Spacer()
                        Text(watchTime).bold()
                    }
                    Button("刷新时长 (需辅助功能权限)") {
                        if let time = ScreenTimeExtractor.extractWatchTime(from: targetApp) {
                            watchTime = time
                        } else {
                            watchTime = "获取失败"
                        }
                    }
                    .disabled(targetApp.isEmpty)
                }
                Section(header: Text("DeepSeek R1 决策")) {
                    SecureField("API Key", text: $deepSeekAPIKey)
                    HStack {
                        Text("AI 建议动作:")
                        Spacer()
                        Text(aiAction).bold()
                    }
                    Button("请求 AI 决策") {
                        deepSeek.requestAction(watchTime: watchTime) { action in
                            DispatchQueue.main.async {
                                aiAction = action
                            }
                        }
                    }
                    .disabled(watchTime == "获取失败" || watchTime == "00:00")
                }
                Section(header: Text("状态")) {
                    Text("音频保活: 运行中").foregroundColor(.green)
                }
                Section {
                    Button("启动完整自动化 (自行接入私有逻辑)") {
                        // 供你自行集成 DTX + UI 测试 + AI 循环
                    }
                    .disabled(true)
                }
            }
            .navigationTitle("AutoTask AI")
        }
    }
}
