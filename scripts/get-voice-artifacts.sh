#!/usr/bin/env bash
set -euo pipefail

OUT="${1:?usage: get-voice-artifacts.sh <outdir>}"

find_voice_repo() {
  if [ -n "${VOICE_REPO:-}" ]; then
    [ -f "$VOICE_REPO/fetch-artifacts.sh" ] || {
      echo "ERROR: VOICE_REPO=$VOICE_REPO has no fetch-artifacts.sh" >&2
      exit 1
    }
    echo "$VOICE_REPO"
    return
  fi
  for c in ../mira-vs ../mira-voice; do
    if [ -f "$c/fetch-artifacts.sh" ]; then
      echo "$c"
      return
    fi
  done
  echo "ERROR: voice repo not found." >&2
  exit 1
}

VR="$(find_voice_repo)"
VR="$(cd "$VR" && pwd)"

if [ -x "$VR/collect-artifacts.sh" ] &&
   [ -d "$VR/../voice-stack" ] &&
   [ -d "$VR/../wakeword-experiment" ]; then
  echo "[voice] local build tree -> collect-artifacts.sh"
  bash "$VR/collect-artifacts.sh" "$OUT"
else
  echo "[voice] fetching pinned bundle from HuggingFace (needs huggingface-cli or git-lfs)"
  bash "$VR/fetch-artifacts.sh"
  rm -rf "$OUT"
  mkdir -p "$OUT"
  cp -a "$VR/artifacts/." "$OUT/"
fi

missing=""
for p in bin lib \
         models/melspectrogram.tflite \
         models/embedding_model.tflite \
         models/hey_mira.tflite \
         zipformer \
         espeak-ng-data; do
  [ -e "$OUT/$p" ] || missing="$missing $p"
done
if [ -n "$missing" ]; then
  echo "ERROR: voice bundle at $OUT is missing:$missing" >&2
  exit 1
fi

echo "[voice] bundle ready -> $OUT ($(du -sh "$OUT" | cut -f1))"
