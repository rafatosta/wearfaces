#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$repo_root"

test_root=$(mktemp -d)
cleanup() {
  rm -rf "$test_root"
}
trap cleanup EXIT

touch "$test_root/kvm"
echo Y > "$test_root/kvm-pmu"
echo N > "$test_root/kvm-ignore-msrs"
cat > "$test_root/podman" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
if [[ ${1:-} == info ]]; then
  echo true
fi
EOF
chmod +x "$test_root/podman"

PATH="$test_root:$PATH" \
  WEARFACES_KVM_DEVICE="$test_root/kvm" \
  WEARFACES_KVM_PMU_STATE_FILE="$test_root/kvm-pmu" \
  WEARFACES_KVM_IGNORE_MSRS_STATE_FILE="$test_root/kvm-ignore-msrs" \
  WEARFACES_KERNEL_RELEASE=6.19.10-300.fc44.x86_64 \
  DISPLAY= WAYLAND_DISPLAY= XDG_RUNTIME_DIR= \
  ./scripts/wearfaces doctor >/dev/null

if PATH="$test_root:$PATH" WEARFACES_DOCTOR_MISSING=podman \
  WEARFACES_KVM_DEVICE="$test_root/kvm" ./scripts/wearfaces doctor >/dev/null 2>&1; then
  echo "Doctor accepted an environment without Podman" >&2
  exit 1
fi

if PATH="$test_root:$PATH" WEARFACES_KVM_DEVICE="$test_root/missing-kvm" \
  WEARFACES_KERNEL_RELEASE=6.19.10-300.fc44.x86_64 \
  WEARFACES_KVM_PMU_STATE_FILE="$test_root/kvm-pmu" \
  WEARFACES_KVM_IGNORE_MSRS_STATE_FILE="$test_root/kvm-ignore-msrs" \
  ./scripts/wearfaces doctor >/dev/null 2>&1; then
  echo "Doctor accepted an environment without KVM" >&2
  exit 1
fi

if PATH="$test_root:$PATH" WEARFACES_KVM_DEVICE="$test_root/kvm" \
  WEARFACES_KERNEL_RELEASE=7.1.10-200.fc44.x86_64 \
  WEARFACES_KVM_PMU_STATE_FILE="$test_root/kvm-pmu" \
  WEARFACES_KVM_IGNORE_MSRS_STATE_FILE="$test_root/kvm-ignore-msrs" \
  ./scripts/wearfaces doctor >/dev/null 2>&1; then
  echo "Doctor accepted the Fedora 44 kernel affected by the Emulator/KVM crash" >&2
  exit 1
fi

echo "Environment doctor self-test passed."
