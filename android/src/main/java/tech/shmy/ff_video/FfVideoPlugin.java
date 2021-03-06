package tech.shmy.ff_video;

import android.app.Activity;
import android.provider.Settings;
import android.view.WindowManager;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** FfVideoPlugin */
public class FfVideoPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private Activity activity;
  private FlutterPluginBinding binding;
  private MethodChannel channel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "ff_video");
    channel.setMethodCallHandler(this);
    this.binding = flutterPluginBinding;

  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch(call.method){
      case "brightness":
        result.success(getBrightness());
        break;
      case "setBrightness":
        double brightness = call.argument("brightness");
        WindowManager.LayoutParams layoutParams = activity.getWindow().getAttributes();
        layoutParams.screenBrightness = (float)brightness;
        activity.getWindow().setAttributes(layoutParams);
        result.success(null);
        break;
      case "isKeptOn":
        int flags = activity.getWindow().getAttributes().flags;
        result.success((flags & WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON) != 0) ;
        break;
      case "keepOn":
        Boolean on = call.argument("on");
        if (on) {
          System.out.println("Keeping screen on ");
          activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        }
        else{
          System.out.println("Not keeping screen on");
          activity.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        }
        result.success(null);
        break;

      default:
        result.notImplemented();
        break;
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  private float getBrightness(){
    float result = activity.getWindow().getAttributes().screenBrightness;
    if (result < 0) { // the application is using the system brightness
      try {
        result = Settings.System.getInt(binding.getApplicationContext().getContentResolver(), Settings.System.SCREEN_BRIGHTNESS) / (float)255;
      } catch (Settings.SettingNotFoundException e) {
        result = 1.0f;
        e.printStackTrace();
      }
    }
    return result;
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    activity = null;
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivity() {
    activity = null;
  }
}
