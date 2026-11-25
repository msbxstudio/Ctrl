import UIKit
import Flutter
import AVFAudio

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var soundEffectAudioChannel: FlutterMethodChannel?
  private var activeSoundEffects = 0

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    registerSoundEffectAudioSession()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  /// Restores external audio after the final overlapping sound effect ends.
  private func registerSoundEffectAudioSession() {
    let registrar = registrar(forPlugin: "SoundEffectAudioSession")!
    let channel = FlutterMethodChannel(
      name: "dev.msbx.ctrl/sound_effect_audio",
      binaryMessenger: registrar.messenger()
    )
    soundEffectAudioChannel = channel
    channel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else {
        result(FlutterError(code: "audio_session_unavailable", message: nil, details: nil))
        return
      }

      do {
        switch call.method {
        case "beginEffect":
          if self.activeSoundEffects == 0 {
            try AVAudioSession.sharedInstance().setActive(true)
          }
          self.activeSoundEffects += 1
        case "endEffect":
          guard self.activeSoundEffects > 0 else {
            result(nil)
            return
          }
          self.activeSoundEffects -= 1
          if self.activeSoundEffects == 0 {
            try AVAudioSession.sharedInstance().setActive(
              false, options: .notifyOthersOnDeactivation
            )
          }
        default:
          result(FlutterMethodNotImplemented)
          return
        }
        result(nil)
      } catch {
        result(FlutterError(
          code: "audio_session_failed", message: error.localizedDescription, details: nil
        ))
      }
    }
  }
}
