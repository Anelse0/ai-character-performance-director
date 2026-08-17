#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Validation failed at line ${LINENO}: ${BASH_COMMAND}" >&2' ERR

skill_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "README.md"
  "SKILL.md"
  "VERSION"
  "agents/openai.yaml"
  "references/shared-principles.md"
  "references/input-schema.md"
  "references/longform-performance-pattern.md"
  "references/acting-craft.md"
  "references/acting-core.md"
  "references/actor-cut.md"
  "references/narrative-performance.md"
  "references/camera-direction.md"
  "references/interaction-performance.md"
  "references/dialogue-listening.md"
  "references/climax-failures.md"
  "references/kling-motion-control.md"
  "references/quality-gates.md"
  "references/performance-review.md"
  "references/evidence-ledger.md"
  "adapters/adapter-contract.md"
  "adapters/seedance-2.md"
  "adapters/seedance-2.5.md"
  "adapters/kling-3.md"
  "tests/acceptance-cases.md"
  "tests/fixtures/seedance25-30s-farewell-monologue.verified.md"
  "tests/fixtures/acting-craft-forward-tests-v1.1.0.md"
  "tests/fixtures/interaction-performance-forward-tests-v1.2.0.md"
  "tests/fixtures/camera-direction-forward-tests-v1.3.0.md"
)

for path in "${required_files[@]}"; do
  test -s "${skill_root}/${path}" || {
    echo "Missing or empty: ${path}" >&2
    exit 1
  }
done

grep -q '^name: ai-character-performance-director$' "${skill_root}/SKILL.md"
grep -q '^VERSION_NAME=1\.7\.0$' "${skill_root}/VERSION"
grep -q '^VERSION_CODE=10700$' "${skill_root}/VERSION"
grep -q '当前版本：`1.7.0`；version code：`10700`' "${skill_root}/README.md"
grep -q '^# AI Character Performance Director$' "${skill_root}/README.md"
grep -q '^## 证据门禁$' "${skill_root}/README.md"
grep -q '`user_approved`：用户明确批准的 Skill 工作流' "${skill_root}/README.md"
grep -q 'kling3-standard-stationary-reunion.verified.md' "${skill_root}/README.md"
grep -q 'actor_cut' "${skill_root}/SKILL.md"
grep -q 'narrative' "${skill_root}/SKILL.md"
grep -q 'environment' "${skill_root}/SKILL.md"
grep -q 'Seedance 2.0 Prompt' "${skill_root}/SKILL.md"
grep -q 'Kling 3.0' "${skill_root}/SKILL.md"
grep -q '不把 FACS' "${skill_root}/SKILL.md"
grep -q 'references/acting-craft.md' "${skill_root}/SKILL.md"
grep -q 'references/performance-review.md' "${skill_root}/SKILL.md"
grep -q 'references/interaction-performance.md' "${skill_root}/SKILL.md"
grep -q 'references/camera-direction.md' "${skill_root}/SKILL.md"
grep -q 'analysis_depth: auto | light | standard | deep' "${skill_root}/SKILL.md"
grep -q 'target_person:' "${skill_root}/SKILL.md"
grep -q 'turning_trigger:' "${skill_root}/SKILL.md"
grep -q 'interaction_class: unilateral_signal | brief_reciprocal_contact | sustained_contact | object_transfer | offscreen_audio | offscreen_physical | spatial_invitation | lens_interaction' "${skill_root}/references/input-schema.md"
grep -q 'target_visualization: allowed | forbidden' "${skill_root}/references/input-schema.md"
grep -q 'render_mode: direct_action | implied_contact_experimental | invite_and_wait | visible_interaction | incompatible' "${skill_root}/references/input-schema.md"
grep -q 'entity_contract:' "${skill_root}/references/input-schema.md"
grep -q 'allowed_owners:' "${skill_root}/references/input-schema.md"
grep -q 'forbidden_owners:' "${skill_root}/references/input-schema.md"
grep -q 'allowed_existing_props:' "${skill_root}/references/input-schema.md"
grep -q 'new_entity_policy: allow | forbid' "${skill_root}/references/input-schema.md"
grep -q 'reflection_policy: preserve | forbid_new' "${skill_root}/references/input-schema.md"
grep -q 'shadow_policy: preserve | forbid_new' "${skill_root}/references/input-schema.md"
grep -q 'source_preflight: pass | block' "${skill_root}/references/input-schema.md"
grep -q '^### 3\. 设计 Camera Unit$' "${skill_root}/SKILL.md"
grep -q '^### 4\. 编译交互可见性与动作可行性$' "${skill_root}/SKILL.md"
grep -q 'camera_intent:' "${skill_root}/SKILL.md"
grep -q 'viewer_relation:' "${skill_root}/references/input-schema.md"
grep -q 'movement_driver:' "${skill_root}/references/input-schema.md"
grep -q 'camera_subject:' "${skill_root}/references/input-schema.md"
grep -q 'spatial_transform: static | translate | rotate | optical | focus' "${skill_root}/references/input-schema.md"
grep -q 'subject_coupling: follow | lead | parallel | counter | reveal | leave_behind | independent' "${skill_root}/references/input-schema.md"
grep -q 'execution_source: prompt | ui_control | start_end_frames | video_reference | custom_multishot' "${skill_root}/references/input-schema.md"
grep -q '`镜头设计`：用一至两行写' "${skill_root}/SKILL.md"
grep -q '`交互处理`：仅在交互任务中输出' "${skill_root}/SKILL.md"
grep -q 'source_preflight: block.*render_mode: incompatible' "${skill_root}/SKILL.md"
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
grep -q 'kling_workflow: auto | standard_single | custom_multi_shot | motion_control' "${skill_root}/references/input-schema.md"
grep -q 'uploaded_video | motion_library' "${skill_root}/references/input-schema.md"
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
grep -q 'root_motion: allowed | bounded | locked' "${skill_root}/references/input-schema.md"
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

camera_reference="${skill_root}/references/camera-direction.md"
grep -q '^## 目录$' "${camera_reference}"
for evidence_id in CAM-ASC-01 CAM-ASC-02 CAM-ASC-03 CAM-ASC-04 CAM-LOCAL-01 USER-CAMERA-01; do
  grep -q "\[${evidence_id}\]" "${camera_reference}" || {
    echo "Missing camera-direction evidence boundary: ${evidence_id}" >&2
    exit 1
  }
done
grep -q 'spatial_transform: static | translate | rotate | optical | focus' "${camera_reference}"
grep -q 'subject_coupling: follow | lead | parallel | counter | reveal | leave_behind | independent' "${camera_reference}"
grep -q '一个镜头只有一个主要运动任务' "${camera_reference}"
grep -q '^### Environment$' "${camera_reference}"
grep -q '静止镜头是正式设计结果' "${camera_reference}"

for camera_contract in camera_prompt_rendering camera_control_surface camera_reference_binding start_end_frame_boundary compound_camera_motion_boundary; do
  grep -q "${camera_contract}:" "${skill_root}/adapters/adapter-contract.md" || {
    echo "Missing camera adapter contract: ${camera_contract}" >&2
    exit 1
  }
done
grep -q '\[K-CAM-01\]' "${skill_root}/adapters/kling-3.md"
grep -q '^### UI Camera Movement$' "${skill_root}/adapters/kling-3.md"
grep -q '^### Start/End Frames$' "${skill_root}/adapters/kling-3.md"
grep -q '^### 镜头参考$' "${skill_root}/adapters/kling-3.md"
grep -q 'camera_execution: video_reference' "${skill_root}/adapters/kling-3.md"
grep -q '最多 6 镜' "${skill_root}/adapters/kling-3.md"
grep -q 'Motion Control 不是相机路径控制' "${skill_root}/adapters/kling-3.md"
grep -q '\[S2-CAM-01\]' "${skill_root}/adapters/seedance-2.md"
grep -q 'video_reference' "${skill_root}/adapters/seedance-2.md"
grep -q '^## Environment 模式$' "${skill_root}/adapters/seedance-2.md"
for evidence_id in K-CAM-01 K-CAM-02 K-CAM-03 K-MS-02 S2-CAM-01 USER-CAMERA-01; do
  grep -q "\[${evidence_id}\]" "${skill_root}/references/evidence-ledger.md" || {
    echo "Missing camera evidence ledger entry: ${evidence_id}" >&2
    exit 1
  }
done
grep -A3 '^### \[USER-CAMERA-01\]' "${skill_root}/references/evidence-ledger.md" | grep -q '状态：`user_approved`'
for evidence_id in USER-POLICY-01 USER-CRAFT-01 USER-CRAFT-02 USER-INTERACTION-01; do
  grep -A3 "^### \[${evidence_id}\]" "${skill_root}/references/evidence-ledger.md" | grep -q '状态：`user_approved`' || {
    echo "Approved workflow is misclassified as generated-result evidence: ${evidence_id}" >&2
    exit 1
  }
done
grep -q '^## C0\. 镜头导演与 Camera Unit$' "${skill_root}/references/quality-gates.md"
grep -q '一至两行镜头设计，包含起幅、驱动、静止或主运镜、落幅和执行方式' "${skill_root}/references/quality-gates.md"
grep -q '不要让新增镜头验收挤掉用户的核心表演或交互要求' "${skill_root}/SKILL.md"
grep -q 'camera_design_mismatch' "${skill_root}/references/performance-review.md"
grep -q '^## I\. 镜头导演与运镜引擎$' "${skill_root}/tests/acceptance-cases.md"
for case_id in I1 I2 I3 I4 I5 I6 I7 I8 I9 I10 I11; do
  grep -q "^### ${case_id}" "${skill_root}/tests/acceptance-cases.md" || {
    echo "Missing camera acceptance case: ${case_id}" >&2
    exit 1
  }
done

interaction_reference="${skill_root}/references/interaction-performance.md"
grep -q '^## 目录$' "${interaction_reference}"
grep -q '^## 3\. 可见实体契约$' "${interaction_reference}"
grep -q 'allowed_owners: \[primary_character\]' "${interaction_reference}"
grep -q 'allowed_existing_props: \[\]' "${interaction_reference}"
grep -q 'source_preflight: pass | block' "${interaction_reference}"
grep -q '^## 5\. 交互类型路由$' "${interaction_reference}"
grep -q 'brief_reciprocal_contact' "${interaction_reference}"
grep -q 'sustained_contact' "${interaction_reference}"
grep -q 'object_transfer' "${interaction_reference}"
grep -q 'offscreen_physical' "${interaction_reference}"
grep -q 'lens_interaction' "${interaction_reference}"
grep -q '^## 6\. 动作识别度编译$' "${interaction_reference}"
grep -q 'surface_orientation:' "${interaction_reference}"
grep -q 'confusable_actions:' "${interaction_reference}"
grep -q 'implied_contact_experimental' "${interaction_reference}"
grep -q '`new_entity_policy: allow`.*不能替代物体交换所需物体' "${interaction_reference}"
grep -q '观众能读出击掌邀请与一次接触暗示' "${interaction_reference}"
grep -q '至少三次同模型、工作流、首帧、时长和 Prompt 的生成全部通过' "${interaction_reference}"

grep -q '实体门禁或接触依赖' "${skill_root}/references/actor-cut.md"
grep -q '实体所有权和物理依赖' "${skill_root}/references/narrative-performance.md"
grep -q 'Motion Control 只解决动作来源与路径控制，不是实体排除工具' "${skill_root}/references/kling-motion-control.md"
grep -q 'render_mode' "${skill_root}/adapters/kling-3.md"
grep -q 'render_mode' "${skill_root}/adapters/seedance-2.md"
grep -q 'interaction_rendering:' "${skill_root}/adapters/adapter-contract.md"
grep -q 'entity_constraint_boundary:' "${skill_root}/adapters/adapter-contract.md"
grep -q '不能把 `incompatible` 改写成可运行 Prompt' "${skill_root}/adapters/adapter-contract.md"
grep -q '^## C1\. 交互表演与实体可见性$' "${skill_root}/references/quality-gates.md"
grep -q 'entity_compliance' "${skill_root}/references/performance-review.md"
grep -q '\[K-I2V-02\]' "${skill_root}/references/evidence-ledger.md"
grep -q '\[USER-K3-03\]' "${skill_root}/references/evidence-ledger.md"
grep -q '\[USER-K3-04\]' "${skill_root}/references/evidence-ledger.md"
grep -q '\[USER-INTERACTION-01\]' "${skill_root}/references/evidence-ledger.md"
grep -q '^## H\. 角色交互表演引擎$' "${skill_root}/tests/acceptance-cases.md"
for case_id in H1 H2 H3 H4 H5 H6 H7 H8 H9 H10; do
  grep -q "^### ${case_id}" "${skill_root}/tests/acceptance-cases.md" || {
    echo "Missing interaction acceptance case: ${case_id}" >&2
    exit 1
  }
done
for interaction_example in 招手致意 召唤注意 制止 指方向 飞吻 比心 击掌 碰拳 轻碰 握手 拥抱 牵手 搀扶 拉人 递杯 接手机 收礼物 喂食 呼唤 警告 提问 打断 拍肩 拉住 触碰 让座 示意靠近 示意进入 敲镜头 擦镜头 遮镜头; do
  grep -q "${interaction_example}" "${skill_root}/tests/acceptance-cases.md" || {
    echo "Missing interaction regression example: ${interaction_example}" >&2
    exit 1
  }
done
grep -q '第二人物、外部身体局部、无关道具、未知归属影子和未知归属倒影' "${skill_root}/tests/acceptance-cases.md"
grep -q '仅设置 `new_entity_policy: allow` 不能代替物体存在或素材绑定' "${skill_root}/tests/acceptance-cases.md"
grep -q '观众能读出击掌邀请及接触暗示' "${skill_root}/tests/acceptance-cases.md"

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

interaction_fixture="${skill_root}/tests/fixtures/interaction-performance-forward-tests-v1.2.0.md"
grep -q '状态：`executed_self_forward_test`' "${interaction_fixture}"
grep -q '版本：`1.2.0`；version code：`10200`' "${interaction_fixture}"
grep -q '不是独立盲测、Kling/Seedance 生成结果或用户成片验证' "${interaction_fixture}"
for case_id in I1 I2 I3 I4 I5 I6 I7 I8 I9 I10; do
  grep -q "^## ${case_id}" "${interaction_fixture}" || {
    echo "Missing interaction forward test: ${case_id}" >&2
    exit 1
  }
done
for interaction_example in 招手致意 召唤注意 制止 指方向 飞吻 比心 碰拳 轻碰 搀扶 拉人 递杯 接手机 收礼物 喂食 呼唤 警告 提问 打断 拍肩 拉住 触碰 让座 示意靠近 示意进入 敲镜头 擦镜头 遮镜头; do
  grep -q "${interaction_example}" "${interaction_fixture}" || {
    echo "Missing interaction forward-test example: ${interaction_example}" >&2
    exit 1
  }
done
grep -q '第二人物、外部身体局部、无关道具、未知归属影子和未知归属倒影' "${interaction_fixture}"
grep -q '观众能否读出击掌邀请与接触暗示' "${interaction_fixture}"

interaction_prompt_start_count="$(grep -c '<!-- PROMPT_OUTPUT_START -->' "${interaction_fixture}")"
interaction_prompt_end_count="$(grep -c '<!-- PROMPT_OUTPUT_END -->' "${interaction_fixture}")"
test "${interaction_prompt_start_count}" -eq 3
test "${interaction_prompt_end_count}" -eq 3

interaction_prompt_outputs="$(awk '
  /<!-- PROMPT_OUTPUT_START -->/ { in_prompt=1; next }
  /<!-- PROMPT_OUTPUT_END -->/ { in_prompt=0; next }
  in_prompt { print }
' "${interaction_fixture}")"
if grep -Eq 'interaction_class:|target_presence:|target_visualization:|reciprocity:|contact_requirement:|external_support:|legibility_without_target:|render_mode:|entity_contract:|source_preflight:' <<<"${interaction_prompt_outputs}"; then
  echo "Interaction forward-test Prompt output leaks internal interaction fields." >&2
  exit 1
fi

for required_phrase in '身体同侧' '手掌保持竖直' '手指朝上' '完整掌面朝向镜头' '短距离前送' '轻微回弹' '不横跨胸前或脸部'; do
  grep -q "${required_phrase}" <<<"${interaction_prompt_outputs}" || {
    echo "High-five forward test missing: ${required_phrase}" >&2
    exit 1
  }
done
if grep -Eq '对方(已经|终于).*(回应|靠近|接触)|完成(了)?(真实)?接触|接住(了)?对方|对方已经坐下' <<<"${interaction_prompt_outputs}"; then
  echo "Interaction forward-test Prompt invents hidden-target feedback or completion." >&2
  exit 1
fi

camera_fixture="${skill_root}/tests/fixtures/camera-direction-forward-tests-v1.3.0.md"
grep -q '状态：`executed_self_forward_test`' "${camera_fixture}"
grep -q '版本：`1.3.0`；version code：`10300`' "${camera_fixture}"
grep -q '不是独立盲测、Kling/Seedance 生成结果或用户成片验证' "${camera_fixture}"
for case_id in C1 C2 C3 C4 C5 C6 C7 C8 C9; do
  grep -q "^## ${case_id}" "${camera_fixture}" || {
    echo "Missing camera forward test: ${case_id}" >&2
    exit 1
  }
done

camera_prompt_start_count="$(grep -c '<!-- PROMPT_OUTPUT_START -->' "${camera_fixture}")"
camera_prompt_end_count="$(grep -c '<!-- PROMPT_OUTPUT_END -->' "${camera_fixture}")"
test "${camera_prompt_start_count}" -eq 9
test "${camera_prompt_end_count}" -eq 9

camera_prompt_outputs="$(awk '
  /<!-- PROMPT_OUTPUT_START -->/ { in_prompt=1; next }
  /<!-- PROMPT_OUTPUT_END -->/ { in_prompt=0; next }
  in_prompt { print }
' "${camera_fixture}")"
if grep -Eq 'camera_intent:|viewer_relation:|movement_driver:|camera_subject:|camera_unit:|spatial_transform:|subject_coupling:|execution_source:|execution_status:' <<<"${camera_prompt_outputs}"; then
  echo "Camera forward-test Prompt output leaks internal camera-analysis fields." >&2
  exit 1
fi
if grep -Eiq 'ARRI|Panavision|Kodak|(^|[^0-9])8K([^0-9]|$)|masterpiece|sweeping cinematic aerial' <<<"${camera_prompt_outputs}"; then
  echo "Camera forward-test Prompt uses equipment or empty blockbuster shorthand instead of a Camera Unit." >&2
  exit 1
fi
for required_phrase in '环境镜头' '固定机位' '平行跟随' 'Custom Multi-Shot' '执行方式' '照片' 'screen direction'; do
  grep -q "${required_phrase}" <<<"${camera_prompt_outputs}" || {
    echo "Camera forward tests missing coverage: ${required_phrase}" >&2
    exit 1
  }
done
for required_case in '复杂人物动作' '双模型适配' '大片质感'; do
  grep -q "${required_case}" "${camera_fixture}" || {
    echo "Camera forward tests missing case: ${required_case}" >&2
    exit 1
  }
done

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

# --- 1.4.0 restructure: complexity dial, extracted schema, shared principles, golden example, freshness ---
grep -q '^### 0\. 复杂度分档（先做）$' "${skill_root}/SKILL.md"
grep -q '快车道 fast' "${skill_root}/SKILL.md"
grep -q 'references/input-schema.md' "${skill_root}/SKILL.md"
grep -q 'references/shared-principles.md' "${skill_root}/SKILL.md"
grep -q '^## 示例（黄金样例）$' "${skill_root}/SKILL.md"
grep -q 'kling3-standard-stationary-reunion.verified.md' "${skill_root}/SKILL.md"
grep -q '输入语义对象' "${skill_root}/references/input-schema.md"
grep -q '设计立场' "${skill_root}/references/shared-principles.md"
grep -q '镜头与演员共用同一执行预算' "${skill_root}/references/shared-principles.md"
grep -q '纯否定护栏尽可能改写为正向状态变化' "${skill_root}/references/shared-principles.md"
grep -q '逐项服从' "${skill_root}/references/shared-principles.md"
grep -q 'official 能力最后核实：2026-08-13' "${skill_root}/references/evidence-ledger.md"
grep -q '无真实生成验证' "${skill_root}/references/evidence-ledger.md"

# --- 1.5.0: Seedance 2.5 adapter + long-form emotional-performance pattern ---
grep -q 'model: both | seedance2 | seedance2_5 | kling3_standard | kling3_omni | kling3_motion_control' "${skill_root}/references/input-schema.md"
grep -q 'seedance2_5' "${skill_root}/SKILL.md"
grep -q 'adapters/seedance-2.5.md' "${skill_root}/SKILL.md"
grep -q 'references/longform-performance-pattern.md' "${skill_root}/SKILL.md"
grep -q 'one-take' "${skill_root}/adapters/seedance-2.5.md"
grep -q '四段 prompt 结构' "${skill_root}/adapters/seedance-2.5.md"
grep -q '五层骨架' "${skill_root}/references/longform-performance-pattern.md"
grep -q '就是用户原 prompt 里的「表演指导」块' "${skill_root}/references/longform-performance-pattern.md"
grep -q '分模型渲染矩阵' "${skill_root}/references/longform-performance-pattern.md"
grep -q '多片输出,不砍内容' "${skill_root}/references/longform-performance-pattern.md"
grep -q 'video1 / video2' "${skill_root}/SKILL.md"
grep -q '## 6\. 可填空模板' "${skill_root}/references/longform-performance-pattern.md"
grep -q '{{角色参考图A}}' "${skill_root}/references/longform-performance-pattern.md"
grep -q '## 7\. 生产步骤' "${skill_root}/references/longform-performance-pattern.md"
grep -q '外显动作库' "${skill_root}/references/longform-performance-pattern.md"
grep -A2 '^### \[S25-FORMULA-01\]' "${skill_root}/references/evidence-ledger.md" | grep -q '状态：`experimental`'
grep -q '第三方待核实' "${skill_root}/references/evidence-ledger.md"

# --- 1.6.0: shape selector, variants, second example, verified-prompt archive ---
lp="${skill_root}/references/longform-performance-pattern.md"
grep -q '形态选择器' "${lp}"
grep -q '单一情绪递进' "${lp}"
grep -q '多情绪转折' "${lp}"
grep -q '双人情绪交流' "${lp}"
grep -q '### 6\.1 L3/L4 形态变体' "${lp}"
grep -q '## 8\. 多情绪转折样例' "${lp}"
grep -q 'seedance25-30s-farewell-monologue.verified.md' "${lp}"
# 单一情绪递进原型内容不得丢失
grep -q '## 6\. 可填空模板' "${lp}"
grep -q '{{角色参考图A}}' "${lp}"
# 委托而非复制：形态选择器指向已有引擎
grep -q 'references/narrative-performance.md' "${lp}"
grep -q 'references/climax-failures.md' "${lp}"
# 已验证 prompt 存档
fixture="${skill_root}/tests/fixtures/seedance25-30s-farewell-monologue.verified.md"
grep -q '状态：`user_verified`' "${fixture}"
grep -q '\[USER-SD25-01\]' "${fixture}"
grep -q 'one emotional truth' "${fixture}"
grep -q '逐字存档：`tests/fixtures/seedance25-30s-farewell-monologue.verified.md`' "${skill_root}/references/evidence-ledger.md"

# --- 1.7.0: emotional prompts use structured shots (verified format), not prose ---
grep -q '情绪表演:结构化分镜' "${skill_root}/adapters/seedance-2.md"
grep -q '不用连续 prose' "${skill_root}/adapters/seedance-2.md"
grep -q '仅限极简单一动作、非情绪片段' "${skill_root}/adapters/seedance-2.md"
grep -q '情绪表演的 Prompt 一律用结构化分镜格式' "${skill_root}/SKILL.md"
for evidence_id in S20-FMT-01 USER-SD20-01; do
  grep -q "\[${evidence_id}\]" "${skill_root}/references/evidence-ledger.md" || {
    echo "Missing Seedance 2.0 format evidence: ${evidence_id}" >&2
    exit 1
  }
done
grep -A2 '^### \[USER-SD20-01\]' "${skill_root}/references/evidence-ledger.md" | grep -q '状态：`user_verified`'
grep -q '回落必须单列一个 Shot' "${skill_root}/references/longform-performance-pattern.md"
grep -q '长篇情绪表演适配' "${skill_root}/adapters/seedance-2.md"
grep -q '长篇情绪独白适配' "${skill_root}/adapters/kling-3.md"
grep -q '越肩前景是高风险' "${skill_root}/adapters/kling-3.md"
for evidence_id in S25-CAP-01 S25-FORMULA-01 USER-SD25-01; do
  grep -q "\[${evidence_id}\]" "${skill_root}/references/evidence-ledger.md" || {
    echo "Missing Seedance 2.5 evidence entry: ${evidence_id}" >&2
    exit 1
  }
done
grep -A2 '^### \[USER-SD25-01\]' "${skill_root}/references/evidence-ledger.md" | grep -q '状态：`user_verified`'

echo "Skill structure and required contracts are valid."
