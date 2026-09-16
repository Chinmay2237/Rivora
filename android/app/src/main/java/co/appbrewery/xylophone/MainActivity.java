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
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.rivora/audio";
    private static final String TAG = "RivoraNativeAudio";

    private SoundPool soundPool;
    private final Map<String, Integer> soundMap = Collections.synchronizedMap(new HashMap<>());
    private final Map<Integer, String> sampleIdToAssetMap = Collections.synchronizedMap(new HashMap<>());
    private final Set<Integer> readySampleIds = Collections.synchronizedSet(new HashSet<>());
    private final Set<Integer> failedSampleIds = Collections.synchronizedSet(new HashSet<>());
    private float globalVolume = 1.0f;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        AudioAttributes audioAttributes = new AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_GAME)
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .build();

        // 48 maxStreams to handle polyphony across all 37 preloaded instruments & rapid taps
        soundPool = new SoundPool.Builder()
                .setMaxStreams(48)
                .setAudioAttributes(audioAttributes)
                .build();

        soundPool.setOnLoadCompleteListener((pool, sampleId, status) -> {
            String asset = sampleIdToAssetMap.get(sampleId);
            if (status == 0) {
                readySampleIds.add(sampleId);
                failedSampleIds.remove(sampleId);
                Log.d(TAG, "[SoundPool OnLoadComplete SUCCESS] Sample ready! soundId: " + sampleId + " asset: " + asset);
            } else {
                failedSampleIds.add(sampleId);
                readySampleIds.remove(sampleId);
                Log.e(TAG, "[SoundPool OnLoadComplete ERROR] Sample load FAILED! soundId: " + sampleId + " status: " + status + " asset: " + asset);
            }
        });

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    switch (call.method) {
                        case "preload":
                            handlePreload(call, result);
                            break;
                        case "preloadAll":
                            handlePreloadAll(call, result);
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

    private int loadSingleAsset(String assetPath) {
        if (soundMap.containsKey(assetPath)) {
            return soundMap.get(assetPath);
        }

        String cleanPath = assetPath.startsWith("assets/") ? assetPath.substring(7) : assetPath;
        String rawPath = assetPath.startsWith("assets/") ? assetPath : "assets/" + assetPath;

        String lookupKeyRaw = FlutterInjector.instance().flutterLoader().getLookupKeyForAsset(rawPath);
        String lookupKeyClean = FlutterInjector.instance().flutterLoader().getLookupKeyForAsset(cleanPath);

        String[] candidateKeys = new String[]{
                lookupKeyRaw,
                lookupKeyClean,
                "flutter_assets/" + rawPath,
                "flutter_assets/" + cleanPath,
                rawPath,
                cleanPath
        };

        // Attempt 1: Direct openFd using candidate asset lookup keys
        for (String key : candidateKeys) {
            if (key == null) continue;
            try {
                AssetFileDescriptor afd = getAssets().openFd(key);
                int soundId = soundPool.load(afd, 1);
                afd.close();
                if (soundId > 0) {
                    soundMap.put(assetPath, soundId);
                    soundMap.put(rawPath, soundId);
                    soundMap.put(cleanPath, soundId);
                    sampleIdToAssetMap.put(soundId, assetPath);
                    Log.d(TAG, "Preloaded asset via openFd: " + assetPath + " (resolved key: " + key + ") -> soundId: " + soundId);
                    return soundId;
                }
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
                if (soundId > 0) {
                    soundMap.put(assetPath, soundId);
                    soundMap.put(rawPath, soundId);
                    soundMap.put(cleanPath, soundId);
                    sampleIdToAssetMap.put(soundId, assetPath);
                    Log.d(TAG, "Preloaded asset via File Cache: " + assetPath + " (" + cacheFile.getAbsolutePath() + ") -> soundId: " + soundId);
                    return soundId;
                }
            } catch (Exception ignored) {
            }
        }

        Log.e(TAG, "Failed to load asset after all attempts: " + assetPath);
        return 0;
    }

    private void handlePreload(MethodCall call, MethodChannel.Result result) {
        String assetPath = call.argument("assetPath");
        if (assetPath == null) {
            result.error("INVALID_ARGUMENT", "assetPath is null", null);
            return;
        }

        int soundId = loadSingleAsset(assetPath);
        if (soundId > 0) {
            result.success(soundId);
        } else {
            result.error("LOAD_ERROR", "Could not load asset file: " + assetPath, null);
        }
    }

    private void handlePreloadAll(MethodCall call, MethodChannel.Result result) {
        List<String> assetPaths = call.argument("assetPaths");
        if (assetPaths == null || assetPaths.isEmpty()) {
            result.error("INVALID_ARGUMENT", "assetPaths is null or empty", null);
            return;
        }

        Map<String, Integer> resultMap = new HashMap<>();
        for (String path : assetPaths) {
            int soundId = loadSingleAsset(path);
            resultMap.put(path, soundId);
        }
        result.success(resultMap);
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

        if (failedSampleIds.contains(soundId)) {
            result.error("LOAD_FAILED", "Native SoundPool failed to decode: " + assetPath, null);
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
        diag.put("failedCount", failedSampleIds.size());

        Map<String, Map<String, Object>> sampleDetails = new HashMap<>();
        for (Map.Entry<String, Integer> entry : soundMap.entrySet()) {
            String asset = entry.getKey();
            int soundId = entry.getValue();
            Map<String, Object> sampleInfo = new HashMap<>();
            sampleInfo.put("soundId", soundId);
            sampleInfo.put("isReady", readySampleIds.contains(soundId));
            sampleInfo.put("isFailed", failedSampleIds.contains(soundId));
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
        failedSampleIds.clear();
        super.onDestroy();
    }
}

