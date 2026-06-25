#!/bin/sh

# install the on-device voice/ML stack into the rootfs
if [ "${BUNDLE_VOICE:-1}" = "0" ]; then
  color_echo "  Stage 20 - voice bundling SKIPPED (BUNDLE_VOICE=0)" -Yellow
  return 0 2>/dev/null || exit 0
fi

VA="${SAVED_PWD}/voice-artifacts"
if [ ! -d "$VA" ]; then
  color_echo "Missing ${VA}. Run 'just prepare' (it runs mira-vs/collect-artifacts.sh)." -Red
  exit 1
fi

# rootfs locations
VLIB="$ROOTFS_PATH/usr/lib/mira/voice" 
VSHARE="$ROOTFS_PATH/usr/share/mira/voice"
mkdir -p "$VLIB/bin" "$VSHARE/models" "$VSHARE/espeak-ng-data"

install -m0755 "$VA"/bin/* "$VLIB/bin/"

cp -a "$VA"/lib/. "$VLIB/"

cp -a "$VA"/models/melspectrogram.tflite \
      "$VA"/models/embedding_model.tflite \
      "$VA"/models/hey_mira.tflite \
      "$VSHARE/models/"

# sherpa gigaspeech-Zipformer
cp -a "$VA"/zipformer "$VSHARE/"

cp -a "$VA"/espeak-ng-data/. "$VSHARE/espeak-ng-data/"

CFG="$ROOTFS_PATH/etc/go-librespot/config.yml"
awk '/^voice:/{exit} {print}' "$CFG" > "$CFG.tmp" && mv -f "$CFG.tmp" "$CFG"
cat >> "$CFG" <<'EOF'

voice:
  enabled: true
  wake: true
  bin_dir: "/usr/lib/mira/voice/bin"
  lib_dir: "/usr/lib/mira/voice"
  model_dir: "/usr/share/mira/voice/models"
  wake_threshold: 0.4
  mic_device: "hw:0,0"
  cascade: true
  espeak_bin: "espeak-ng"
  espeak_data_dir: "/usr/share/mira/voice"
  cache_dir: "/var/local/mira/voice/cache"
  catalog_sync: true
  accept_threshold: 0.42
  sherpa_enabled: true
  sherpa_bin: "sherpa_asr_server"
  sherpa_model_dir: "/usr/share/mira/voice/zipformer/sherpa-onnx-zipformer-gigaspeech-2023-12-12"
EOF

color_echo "  voice stack installed (lib=$(du -sh "$VLIB" 2>/dev/null | cut -f1) share=$(du -sh "$VSHARE" 2>/dev/null | cut -f1))" -Green
