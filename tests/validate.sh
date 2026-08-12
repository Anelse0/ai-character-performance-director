#!/usr/bin/env bash
set -euo pipefail

skill_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "README.md"
  "SKILL.md"
  "VERSION"
  "agents/openai.yaml"
  "references/acting-craft.md"
  "references/acting-core.md"
  "references/actor-cut.md"
  "references/narrative-performance.md"
  "references/dialogue-listening.md"
  "references/climax-failures.md"
  "references/kling-motion-control.md"
  "references/quality-gates.md"
  "references/performance-review.md"
  "references/evidence-ledger.md"
  "adapters/adapter-contract.md"
  "adapters/seedance-2.md"
  "adapters/kling-3.md"
  "tests/acceptance-cases.md"
  "tests/fixtures/acting-craft-forward-tests-v1.1.0.md"
)

for path in "${required_files[@]}"; do
  test -s "${skill_root}/${path}" || {
    echo "Missing or empty: ${path}" >&2
    exit 1
  }
done

grep -q '^name: ai-character-performance-director$' "${skill_root}/SKILL.md"
grep -q '^VERSION_NAME=1\.1\.0$' "${skill_root}/VERSION"
grep -q '^VERSION_CODE=10100$' "${skill_root}/VERSION"
grep -q '当前版本：`1.1.0`；version code：`10100`' "${skill_root}/README.md"
grep -q '^# AI Character Performance Director$' "${skill_root}/README.md"
grep -q '^## 证据门禁$' "${skill_root}/README.md"
grep -q 'kling3-standard-stationary-reunion.verified.md' "${skill_root}/README.md"
grep -q 'actor_cut' "${skill_root}/SKILL.md"
grep -q 'narrative' "${skill_root}/SKILL.md"
grep -q 'Seedance 2.0 Prompt' "${skill_root}/SKILL.md"
grep -q 'Kling 3.0' "${skill_root}/SKILL.md"
grep -q '不把 FACS' "${skill_root}/SKILL.md"
grep -q 'references/acting-craft.md' "${skill_root}/SKILL.md"
grep -q 'references/performance-review.md' "${skill_root}/SKILL.md"
grep -q 'analysis_depth: auto | light | standard | deep' "${skill_root}/SKILL.md"
grep -q 'target_person:' "${skill_root}/SKILL.md"
grep -q 'turning_trigger:' "${skill_root}/SKILL.md"
grep -q '至少在内部考虑两个真正不同的 tactic' "${skill_root}/SKILL.md"
grep -q '4–6 秒：trigger → 一次可见 tactic → ending' "${skill_root}/SKILL.md"
grep -q '7–10 秒：baseline → trigger → tactic → 可定位反馈或明确等待 → 一次调整或 ending' "${skill_root}/SKILL.md"
if grep -Eq '刺激 → 第一次变化 → 结束状态|基线 → 刺激 → 处理 → 行动/选择 → 结束状态' "${skill_root}/SKILL.md"; then
  echo "SKILL.md still contains the legacy emotion-state timing chain." >&2
  exit 1
fi
grep -q '4–6 秒只保留 trigger、一次指向 target 的可见 tactic 与 ending' "${skill_root}/references/actor-cut.md"
grep -q '^### 风格契约解析顺序$' "${skill_root}/references/acting-craft.md"
grep -q '不擅自补写“写实、克制”' "${skill_root}/references/acting-craft.md"
grep -q '^## 目录$' "${skill_root}/references/acting-craft.md"
grep -q '\[ACT-RADA-01\]' "${skill_root}/references/acting-craft.md"
grep -q '\[ACT-TRINITY-01\]' "${skill_root}/references/acting-craft.md"
grep -q '\[ACT-LAMDA-01\]' "${skill_root}/references/acting-craft.md"
grep -q '\[ACT-RESEARCH-01\]' "${skill_root}/references/acting-craft.md"
grep -q '\[ACT-RESEARCH-02\]' "${skill_root}/references/acting-craft.md"
grep -q '\[USER-CRAFT-01\]' "${skill_root}/references/acting-craft.md"
grep -q '\[USER-CRAFT-02\]' "${skill_root}/references/acting-craft.md"
grep -q '本 Reference 不重新选择表演策略' "${skill_root}/references/acting-core.md"
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
grep -q '\[USER-CRAFT-01\]' "${skill_root}/references/evidence-ledger.md"
grep -q '\[USER-CRAFT-02\]' "${skill_root}/references/evidence-ledger.md"
grep -q '\[K-I2V-01\]' "${skill_root}/references/evidence-ledger.md"
grep -q '连续因果 prose' "${skill_root}/adapters/seedance-2.md"
grep -q '^## G\. 演技提升引擎$' "${skill_root}/tests/acceptance-cases.md"
grep -q '不能宣称实际成片演技成立' "${skill_root}/tests/acceptance-cases.md"
grep -q '不使用综合演技总分' "${skill_root}/tests/acceptance-cases.md"

craft_fixture="${skill_root}/tests/fixtures/acting-craft-forward-tests-v1.1.0.md"
grep -q '状态：`executed_self_forward_test`' "${craft_fixture}"
grep -q 'version code：`10100`' "${craft_fixture}"
for case_id in G1 G2 G3 G4 G5 G6 G7 G8 G9; do
  grep -q "## ${case_id}" "${craft_fixture}" || {
    echo "Missing acting-craft forward test: ${case_id}" >&2
    exit 1
  }
done

prompt_start_count="$(grep -c '<!-- PROMPT_OUTPUT_START -->' "${craft_fixture}")"
prompt_end_count="$(grep -c '<!-- PROMPT_OUTPUT_END -->' "${craft_fixture}")"
test "${prompt_start_count}" -eq 6
test "${prompt_end_count}" -eq 6

prompt_outputs="$(awk '
  /<!-- PROMPT_OUTPUT_START -->/ { in_prompt=1; next }
  /<!-- PROMPT_OUTPUT_END -->/ { in_prompt=0; next }
  in_prompt { print }
' "${craft_fixture}")"
if grep -Eq 'analysis_depth:|style_contract:|stakes:|obstacle:|expected_effect:|turning_trigger:|候选 tactic' <<<"${prompt_outputs}"; then
  echo "Forward-test Prompt output leaks internal acting-analysis fields." >&2
  exit 1
fi

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
