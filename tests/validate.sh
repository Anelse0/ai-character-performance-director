#!/usr/bin/env bash
set -euo pipefail

skill_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "README.md"
  "SKILL.md"
  "agents/openai.yaml"
  "references/acting-core.md"
  "references/actor-cut.md"
  "references/narrative-performance.md"
  "references/dialogue-listening.md"
  "references/climax-failures.md"
  "references/kling-motion-control.md"
  "references/quality-gates.md"
  "adapters/adapter-contract.md"
  "adapters/seedance-2.md"
  "adapters/kling-3.md"
  "tests/acceptance-cases.md"
)

for path in "${required_files[@]}"; do
  test -s "${skill_root}/${path}" || {
    echo "Missing or empty: ${path}" >&2
    exit 1
  }
done

grep -q '^name: ai-character-performance-director$' "${skill_root}/SKILL.md"
grep -q '^# AI Character Performance Director$' "${skill_root}/README.md"
grep -q '^## 证据门禁$' "${skill_root}/README.md"
grep -q 'kling3-standard-stationary-reunion.verified.md' "${skill_root}/README.md"
grep -q 'actor_cut' "${skill_root}/SKILL.md"
grep -q 'narrative' "${skill_root}/SKILL.md"
grep -q 'Seedance 2.0 Prompt' "${skill_root}/SKILL.md"
grep -q 'Kling 3.0' "${skill_root}/SKILL.md"
grep -q '不把 FACS' "${skill_root}/SKILL.md"
grep -q '非模板性自检' "${skill_root}/references/acting-core.md"
grep -q '每镜一个戏剧任务' "${skill_root}/adapters/kling-3.md"
grep -q 'Standard/Omni 演员 Cut 情绪 Prompt：强制输出框架' "${skill_root}/adapters/kling-3.md"
grep -q '时间前不得添加“约”' "${skill_root}/adapters/kling-3.md"
grep -q 'Kling 演员 Cut 情绪输出框架' "${skill_root}/references/actor-cut.md"
grep -q 'Kling Standard/Omni 演员 Cut 情绪格式' "${skill_root}/tests/acceptance-cases.md"
grep -q 'kling_workflow: auto | standard_single | custom_multi_shot | motion_control' "${skill_root}/SKILL.md"
grep -q 'uploaded_video | motion_library' "${skill_root}/SKILL.md"
grep -q '以上路由阈值是本 skill 的可靠性策略' "${skill_root}/references/kling-motion-control.md"
grep -q '## Motion Unit' "${skill_root}/references/kling-motion-control.md"
grep -q '机械联动属于同一 Motion Unit' "${skill_root}/references/quality-gates.md"
grep -q '复杂动作拆解与负荷' "${skill_root}/tests/acceptance-cases.md"
grep -q 'establish → naturally adjust → reacquire' "${skill_root}/references/kling-motion-control.md"
grep -q 'Facial Element 只提供脸部信息' "${skill_root}/references/kling-motion-control.md"
grep -q '对镜眼神协调' "${skill_root}/tests/acceptance-cases.md"
grep -q '复杂情绪参考' "${skill_root}/tests/acceptance-cases.md"
grep -q '^## Motion Control$' "${skill_root}/adapters/kling-3.md"
grep -q '补充 Prompt 没有重复或冲突的动作时间线' "${skill_root}/references/quality-gates.md"
grep -q 'Motion Control 输出契约' "${skill_root}/tests/acceptance-cases.md"
grep -q 'Motion Control 不再要求动作来源必须是真人视频' "${skill_root}/tests/acceptance-cases.md"
grep -q 'root_motion: allowed | bounded | locked' "${skill_root}/SKILL.md"
grep -q '原地表演与根位移锁定' "${skill_root}/references/kling-motion-control.md"
grep -q '待验证实验版本' "${skill_root}/adapters/kling-3.md"
grep -q '原地表演与根位移' "${skill_root}/references/quality-gates.md"
grep -q '原地表演与根位移锁定' "${skill_root}/tests/acceptance-cases.md"
grep -q '\[K-MC-01\]' "${skill_root}/references/evidence-ledger.md"
grep -q '\[USER-K3-01\]' "${skill_root}/references/evidence-ledger.md"
grep -q '\[USER-K3-02\]' "${skill_root}/references/evidence-ledger.md"
grep -q '\[K-I2V-01\]' "${skill_root}/references/evidence-ledger.md"
grep -q '连续因果 prose' "${skill_root}/adapters/seedance-2.md"

stationary_fixture="${skill_root}/tests/fixtures/kling3-standard-stationary-reunion.verified.md"
test -f "${stationary_fixture}"
grep -q '状态：`user_verified`' "${stationary_fixture}"
grep -q '0–1.3s' "${stationary_fixture}"
grep -q '1.3–2.8s' "${stationary_fixture}"
grep -q '2.8–5.7s' "${stationary_fixture}"
grep -q '5.7–8s' "${stationary_fixture}"
grep -q '双脚持续承重' "${stationary_fixture}"
grep -q '人物与镜头的距离保持不变' "${stationary_fixture}"
grep -q '沿身体横向向左右打开' "${stationary_fixture}"
if grep -Eq '【约|向镜头前倾|靠近镜头|迎接|拥抱|退回|回到原位|向前|向后|同时' "${stationary_fixture}"; then
  echo "Stationary Kling regression fixture contains conflicting spatial language." >&2
  exit 1
fi

while IFS= read -r relative_path; do
  test -e "${skill_root}/${relative_path}" || {
    echo "Broken local reference: ${relative_path}" >&2
    exit 1
  }
done < <(grep -oE '`(references|adapters)/[^`]+\.md`' "${skill_root}/SKILL.md" | tr -d '`')

echo "Skill structure and required contracts are valid."
