package kiradev.studio.japaneseapp;

import io.flutter.embedding.android.FlutterActivity;
import android.content.Context;
import android.view.inputmethod.InputMethodInfo;
import android.view.inputmethod.InputMethodManager;
import java.util.List;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import android.provider.Settings;

import kiradev.studio.japaneseapp.KeyboardHelper; // Sửa import

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "keyboard_check";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if (call.method.equals("isGboardInstalled")) {
                        result.success(isGboardInstalled(this));
                    } else if (call.method.equals("showInputMethodPicker")) {
                        showInputMethodPicker(this);
                        result.success(null);
                    } else if (call.method.equals("isUsingGboard")) {
                        boolean isGboard = KeyboardHelper.isUsingGboard(this);
                        result.success(isGboard);
                    } else {
                        result.notImplemented();
                    }
                });
    }

    // Kiểm tra Gboard có được cài chưa
    private boolean isGboardInstalled(Context context) {
        InputMethodManager imm = (InputMethodManager) context.getSystemService(Context.INPUT_METHOD_SERVICE);
        if (imm == null) return false;

        List<InputMethodInfo> inputMethods = imm.getEnabledInputMethodList();
        for (InputMethodInfo method : inputMethods) {
            if (method.getPackageName().equals("com.google.android.inputmethod.latin")) {
                return true; // Gboard được cài đặt
            }
        }
        return false;
    }

    // Mở menu chuyển đổi bàn phím
    private void showInputMethodPicker(Context context) {
        InputMethodManager imm = (InputMethodManager) context.getSystemService(Context.INPUT_METHOD_SERVICE);
        if (imm != null) {
            imm.showInputMethodPicker();
        }
    }
}
