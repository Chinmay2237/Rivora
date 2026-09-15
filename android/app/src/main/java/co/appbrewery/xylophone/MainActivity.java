package co.appbrewery.xylophone;

import android.content.res.AssetFileDescriptor;
import android.media.AudioAttributes;
import android.media.SoundPool;
import android.util.Log;
import androidx.annotation.NonNull;
import io.flutter.FlutterInjector;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.rivora/audio";
    private static final String TAG = "RivoraNativeAudio";

    private SoundPool soundPool;
    private final Map<String, Integer> soundMap = Collections.synchronizedMap(new HashMap<>());
    private final Map<Integer, String> sampleIdToAssetMap = Collections.synchronizedMap(new HashMap<>());
    private final Set<Integer> readySampleIds = Collections.synchronizedSet(new HashSet<>());
    private float globalVolume = 1.0f;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        AudioAttributes audioAttributes = new AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_GAME)
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .build();

        soundPool = new SoundPool.Builder()
                .setMaxStreams(16)
                .setAudioAttributes(audioAttributes)
                .build();

        soundPool.setOnLoadCompleteListener((pool, sampleId, status) -> {
            String asset = sampleIdToAssetMap.get(sampleId);
            if (status == 0) {
                readySampleIds.add(sampleId);
                Log.d(TAG, "[SoundPool OnLoadComplete] Sample ready! soundId: " + sampleId + " asset: " + asset);
            } else {
                Log.e(TAG, "[SoundPool OnLoadComplete ERROR] Sample load FAILED! soundId: " + sampleId + " status: " + status + " asset: " + asset);
            }
        });

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    switch (call.method) {
                        case "preload":
                            handlePreload(call, result);
                            break;
                        case "play":
                            handlePlay(call, result);
                            break;
                        case "stopAll":
                            handleStopAll(result);
                            break;
                        case "setVolume":
                            handleSetVolume(call, result);
                            break;
                        case "getDiagnosticState":
                            handleGetDiagnosticState(result);
                            break;
                        default:
                            result.notImplemented();
                            break;
                    }
                });
    }

    private void handlePreload(MethodCall call, MethodChannel.Result result) {
        String assetPath = call.argument("assetPath");
        if (assetPath == null) {
            result.error("INVALID_ARGUMENT", "assetPath is null", null);
            return;
        }

        if (soundMap.containsKey(assetPath)) {
            result.success(soundMap.get(assetPath));
            return;
        }

        String flutterKey = FlutterInjector.instance().flutterLoader().getLookupKeyForAsset(assetPath);
        String flutterKeyWithAssets = FlutterInjector.instance().flutterLoader().getLookupKeyForAsset("assets/" + assetPath);
        String[] candidateKeys = new String[]{
                flutterKey,
                flutterKeyWithAssets,
                "flutter_assets/" + assetPath,
                "flutter_assets/assets/" + assetPath,
                assetPath
        };

        // Attempt 1: Direct openFd using candidate asset lookup keys
        for (String key : candidateKeys) {
            if (key == null) continue;
            try {
                AssetFileDescriptor afd = getAssets().openFd(key);
                int soundId = soundPool.load(afd, 1);
                afd.close();
                soundMap.put(assetPath, soundId);
                sampleIdToAssetMap.put(soundId, assetPath);
                Log.d(TAG, "Preloaded asset via openFd: " + assetPath + " (key: " + key + ") -> soundId: " + soundId);
                result.success(soundId);
                return;
            } catch (Exception ignored) {
            }
        }

        // Attempt 2: Startup File Cache Fallback (uncompresses asset stream to cache file ONCE on launch)
        for (String key : candidateKeys) {
            if (key == null) continue;
            try (InputStream is = getAssets().open(key)) {
                File cacheDir = new File(getCacheDir(), "sound_cache");
                if (!cacheDir.exists()) cacheDir.mkdirs();

                String safeFileName = assetPath.replaceAll("[^a-zA-Z0-9._-]", "_");
                File cacheFile = new File(cacheDir, safeFileName);

                if (!cacheFile.exists() || cacheFile.length() == 0) {
                    try (FileOutputStream fos = new FileOutputStream(cacheFile)) {
                        byte[] buffer = new byte[8192];
                        int read;
                        while ((read = is.read(buffer)) != -1) {
                            fos.write(buffer, 0, read);
                        }
                        fos.flush();
                    }
                }

                int soundId = soundPool.load(cacheFile.getAbsolutePath(), 1);
                soundMap.put(assetPath, soundId);
                sampleIdToAssetMap.put(soundId, assetPath);
                Log.d(TAG, "Preloaded asset via File Cache: " + assetPath + " (" + cacheFile.getAbsolutePath() + ") -> soundId: " + soundId);
                result.success(soundId);
                return;
            } catch (Exception ignored) {
            }
        }

        Log.e(TAG, "Failed to load asset after all attempts: " + assetPath);
        result.error("LOAD_ERROR", "Could not load asset file: " + assetPath, null);
    }

    private void handlePlay(MethodCall call, MethodChannel.Result result) {
        String assetPath = call.argument("assetPath");
        Double volArg = call.argument("volume");
        float vol = (volArg != null) ? volArg.floatValue() : globalVolume;

        if (assetPath == null) {
            result.error("INVALID_ARGUMENT", "assetPath is null", null);
            return;
        }

        Integer soundId = soundMap.get(assetPath);
        if (soundId == null || soundId <= 0) {
            result.error("NOT_FOUND", "Sound not preloaded: " + assetPath, null);
            return;
        }

        if (!readySampleIds.contains(soundId)) {
            Log.w(TAG, "Sound not ready yet: " + assetPath + " soundId: " + soundId);
            result.error("NOT_READY", "Sound is still decoding/loading: " + assetPath, null);
            return;
        }

        if (soundPool != null) {
            int streamId = soundPool.play(soundId, vol, vol, 1, 0, 1.0f);
            if (streamId != 0) {
                result.success(streamId);
            } else {
                Log.e(TAG, "soundPool.play returned streamId 0 for asset: " + assetPath + " soundId: " + soundId);
                result.error("PLAY_FAILED", "soundPool.play returned streamId 0", null);
            }
        } else {
            result.error("ENGINE_NULL", "SoundPool is null", null);
        }
    }

    private void handleStopAll(MethodChannel.Result result) {
        if (soundPool != null) {
            soundPool.autoPause();
        }
        result.success(true);
    }

    private void handleSetVolume(MethodCall call, MethodChannel.Result result) {
        Double volArg = call.argument("volume");
        if (volArg != null) {
            globalVolume = volArg.floatValue();
        }
        result.success(globalVolume);
    }

    private void handleGetDiagnosticState(MethodChannel.Result result) {
        Map<String, Object> diag = new HashMap<>();
        diag.put("soundPoolInitialized", soundPool != null);
        diag.put("totalPreloaded", soundMap.size());
        diag.put("readyCount", readySampleIds.size());

        Map<String, Map<String, Object>> sampleDetails = new HashMap<>();
        for (Map.Entry<String, Integer> entry : soundMap.entrySet()) {
            String asset = entry.getKey();
            int soundId = entry.getValue();
            Map<String, Object> sampleInfo = new HashMap<>();
            sampleInfo.put("soundId", soundId);
            sampleInfo.put("isReady", readySampleIds.contains(soundId));
            sampleDetails.put(asset, sampleInfo);
        }
        diag.put("samples", sampleDetails);
        result.success(diag);
    }

    @Override
    protected void onDestroy() {
        if (soundPool != null) {
            soundPool.release();
            soundPool = null;
        }
        soundMap.clear();
        sampleIdToAssetMap.clear();
        readySampleIds.clear();
        super.onDestroy();
    }
}
