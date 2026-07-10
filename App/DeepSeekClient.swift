import Foundation

class DeepSeekClient {
    private let apiKey: String
    private let baseURL = "https://api.deepseek.com/v1/chat/completions"

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    func requestAction(watchTime: String, completion: @escaping (String) -> Void) {
        let prompt = """
        你是一个短视频自动观看决策助手。当前视频已观看时长：\(watchTime)。
        请从以下动作中选择一个最适合的：swipe_up（滑走）、like（点赞）、stay（继续观看）。
        只回复动作名，不要解释。
        """

        let messages: [[String: String]] = [
            ["role": "user", "content": prompt]
        ]
        let body: [String: Any] = [
            "model": "deepseek-r1",
            "messages": messages,
            "stream": false
        ]
        guard let url = URL(string: baseURL) else {
            completion("swipe_up")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("DeepSeek API error: \(error)")
                completion("swipe_up")
                return
            }
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let choices = json["choices"] as? [[String: Any]],
                  let message = choices.first?["message"] as? [String: Any],
                  let content = message["content"] as? String else {
                completion("swipe_up")
                return
            }
            let action = content.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            completion(action)
        }.resume()
    }
}
