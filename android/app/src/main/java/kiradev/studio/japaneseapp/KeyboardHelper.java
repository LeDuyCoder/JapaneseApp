package kiradev.studio.japaneseapp;

import android.content.Context;
import android.provider.Settings;

public class KeyboardHelper {
    public static boolean isUsingGboard(Context context) {
        String defaultInputMethod = Settings.Secure.getString(
                context.getContentResolver(),
                Settings.Secure.DEFAULT_INPUT_METHOD
        );
        return defaultInputMethod.contains("com.google.android.inputmethod.latin");
    }
}