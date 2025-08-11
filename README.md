# workspace

A new Flutter project.



## Running the App with Environment Variables

We use `--dart-define` for passing API keys and environment-specific configs.

Usage:

```dart
const supabaseUrl = String.fromEnvironment('supabaseUrl');
const supabaseAnonKey = String.fromEnvironment('supabaseAnonKey');
```

### Development (VS Code)
Environment variables can be configured directly in `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter Dev",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "args": [
        "--dart-define=supabaseUrl=https://your-project.supabase.co",
        "--dart-define=supabaseAnonKey=your-anon-key"
      ]
    }
  ]
}
```
⚠️ Do not commit secrets to Git. Keep launch.json local or use placeholder/example values in the repository.

### Development (CLI)

```bash
flutter run \
  --dart-define=supabaseUrl=https://your-project.supabase.co \
  --dart-define=supabaseAnonKey=your-anon-key
```

### Release Build
#### Android APK
```bash
flutter build apk --release \
  --dart-define=supabaseUrl=https://your-project.supabase.co \
  --dart-define=supabaseAnonKey=your-anon-key
```

#### Android App Bundle
```bash
flutter build appbundle --release \
  --dart-define=supabaseUrl=https://your-project.supabase.co \
  --dart-define=supabaseAnonKey=your-anon-key
```

#### iOS
```bash
flutter build ios --release \
  --dart-define=supabaseUrl=https://your-project.supabase.co \
  --dart-define=supabaseAnonKey=your-anon-key
```

In CI/CD pipelines, pass --dart-define values from environment variables or secrets storage.
Remember: Any value included in the app binary can be extracted, so do not store truly private credentials in the client app.

